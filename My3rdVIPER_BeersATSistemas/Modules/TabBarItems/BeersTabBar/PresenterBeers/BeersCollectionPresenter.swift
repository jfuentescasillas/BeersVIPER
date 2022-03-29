//
//  BeersCollectionPresenter.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 15/03/22.
//


import Foundation


class BeersCollectionPresenter: BeerCollectionPresenterContract {
	// MARK: - Properties
	// MARK: Properties related with the PresenterContract
	var view: BeersCollectionViewContract?
	var interactor: BeerCollectionInteractorContract?
	var wireframe: BeerCollectionWireframeContract?
	
	var numBeers: Int {
		return beers.count
	}
	
	// MARK: - Private Class Properties
	private var beers = [BeerModel]() {
		didSet {
			view?.reloadData()
		}
	}
	private var pageNumber: Int  = 1  // This is needed for the pagination
	var hasMoreBeers: Bool 		 = true
	var isLoadingMoreBeers: Bool = false
	
	
	// MARK: - Methods related with the PresenterContract
	func viewDidLoad() {
		isLoadingMoreBeers = true
		
		interactor?.output = self
		interactor?.fetchBeers(pageNumber: pageNumber)
		
		view?.startActivity()
	}
	
	
	func cellViewModel(at indexPath: IndexPath) -> BeerCollectionViewCellViewModel {
		let item = beers[indexPath.row]
				
		return item.toCollectionCellViewModel
	}
	
	
	func didSelectItem(at indexPath: IndexPath) {
		let beerID: Int = beers[indexPath.row].id
		/*print("The BeerName of the clicked cell is: \(beers[indexPath.row].name) (in BeersCollectionPresenter)")
		print("BeerID: \(beerID) (in BeersCollectionPresenter)")*/
		
		wireframe?.navigate(to: beerID)
	}
	
	
	func fetchNextItems() {
		guard !isLoadingMoreBeers && hasMoreBeers else { return }
		
		isLoadingMoreBeers = true
		pageNumber += 1
		/*print("PageNumber: \(pageNumber)")
		print("isLoadingMoreBeers (it should be 'true'): \(isLoadingMoreBeers)")*/
		
		interactor?.fetchBeers(pageNumber: pageNumber)
		view?.startActivity()
	}
	
	
	// MARK: - Deinit
	deinit {
		print("Deinit \(self)")
	}
}


// MARK: - Extension: BeerCollectionInteractorOutputContract
extension BeersCollectionPresenter: BeerCollectionInteractorOutputContract {
	// The presenter receives the data from the Interactor. The methods below are called from the Interactor
	func didFetch(beers: [BeerModel]) {
		print("beers.count (insideDidFecth): \(beers.count)")
		
		if beers.count != 80 {
			hasMoreBeers = false
		}
		
		self.beers += beers
		print("Self.beers: \(self.beers)")
		print("Self.beers.count: \(self.beers.count)")
		
		isLoadingMoreBeers = false
		//print("isLoadingMoreBeers (it should be 'false'): \(isLoadingMoreBeers)")
		
		view?.stopAndHideActivity()
	}
	
	
	func fetchDidFail(error: String) {
		print("Fetch failed with this error (in BeersCollectionPresenter): ", error)
	}
}
