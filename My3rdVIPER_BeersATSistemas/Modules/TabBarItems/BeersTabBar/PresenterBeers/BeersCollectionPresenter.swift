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
	
	// MARK: Private Class Properties
	private var beers = [BeerModel]() {
		didSet {
			view?.reloadData()
		}
	}
	private var pageNumber: Int  	 = 1   // This is needed for the pagination
	private var searchedName: String = ""  // When the user searches for a beer's name, it will be stored in this variable
	var hasMoreBeers: Bool 		 	 = true
	var isLoadingMoreBeers: Bool 	 = false
	var isSearchingBeers: Bool   	 = false
	
	
	// MARK: - Methods related with the PresenterContract
	func viewDidLoad() {
		hasMoreBeers 	   = true
		isLoadingMoreBeers = false
		isSearchingBeers   = false
				
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
		
		if isSearchingBeers {
			interactor?.searchBeers(beerName: searchedName, pageNumber: pageNumber)
		} else {
			interactor?.fetchBeers(pageNumber: pageNumber)
		}
		
		view?.startActivity()
	}
	
	
	func fetchSearchedItems(searchedName: String) {
		self.searchedName  = searchedName
		isLoadingMoreBeers = false
		hasMoreBeers 	   = true
		isSearchingBeers   = true
		beers 			   = []  // Empty the current array of beers
		pageNumber 		   = 1  // Each time a beer search is done, the page number must be reset to 1
		
		view?.searchBeerIsActive()  // The "reset" button is activated in the view
		interactor?.searchBeers(beerName: searchedName, pageNumber: pageNumber)
		
		view?.startActivity()
	}
	
	
	// Reset all the values and a new fetch of beers is done.
	func resetButtonPressed() {
		beers = []
		pageNumber = 1
		viewDidLoad()
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
		// If the fetched items is lower than the maximum value (in this case 80), then it deactivates the pagination by setting "hasMoreBeers" to false
		if beers.count < 80 {
			hasMoreBeers = false
		}
		
		if beers.count == 0 {
			view?.showEmptyResultsLabel()
			
			return
		}
		
		self.beers += beers
		isLoadingMoreBeers = false
		
		view?.stopAndHideActivity()
	}
	
	
	func fetchDidFail(error: String) {
		print("Fetch failed with this error (in BeersCollectionPresenter): ", error)
	}
}
