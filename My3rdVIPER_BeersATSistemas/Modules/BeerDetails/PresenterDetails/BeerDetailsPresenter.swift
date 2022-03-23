//
//  BeerDetailsPresenter.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 18/03/22.
//


import Foundation


class BeerDetailsPresenter: BeerDetailsPresenterContract {
	var view: BeerDetailsViewContract?
	var interactor: BeerDetailsInteractorContract?
	var beerID: Int?
	
	
	init(beerID: Int) {
		self.beerID = beerID
	}
	
	
	func viewDidLoad() {
		buildDetailsViewModel()
	}
	
	
	func buildDetailsViewModel() /*-> BeerDetailsViewModel*/ {
		print("beerID: \(String(describing: beerID)) (insideBeerDetailsPresenter)")
		interactor?.fetchBeer(withID: beerID ?? 1)
		
		//return interactor?.fetchBeer(withID: beerID ?? 1)
	}
}


// MARK: - Extension: BeerDetailsInteractorOutputContract
extension BeerDetailsPresenter: BeerDetailsInteractorOutputContract {
	func didFetch(beer: BeerModel) {
		print("Beer in didFetch (in BeerDetailsPresenter, InteractorOutputContract): \(beer)")		
	}
	
	
	func fetchDidFail(error: String) {
		print("Error Fetching BeerID: \(error)")
	}
}
