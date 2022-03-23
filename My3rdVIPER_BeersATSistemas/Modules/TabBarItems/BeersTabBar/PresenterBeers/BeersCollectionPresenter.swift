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
	
	
	func viewDidLoad() {
		interactor?.output = self
		interactor?.fetchBeers()
		//fetchBeers()
	}
	
	
	func cellViewModel(at indexPath: IndexPath) -> BeerCollectionViewCellViewModel {
		let item = beers[indexPath.row]
				
		return item.toCollectionCellViewModel
	}
	
	
	func didSelectItem(at indexPath: IndexPath) {
		let beerID: Int = beers[indexPath.row].id
		print("The BeerName of the clicked cell is: \(beers[indexPath.row].name) (in BeersCollectionPresenter)")
		print("BeerID: \(beerID) (in BeersCollectionPresenter)")
		
		wireframe?.navigate(to: beerID)
	}
	
	
	// MARK: - Class private methods (not related with the PresenterContract)
	/*private func fetchBeers() {
	 
	 }*/
}


// MARK: - Extension: BeerCollectionInteractorOutputContract
extension BeersCollectionPresenter: BeerCollectionInteractorOutputContract {
	// The presenter receives the data from the Interactor. The methods below are called from the Interactor
	func didFetch(beers: [BeerModel]) {
		self.beers = beers
	}
	
	
	func fetchDidFail(error: String) {
		print("Fetch failed with this error: ", error)
	}
}
