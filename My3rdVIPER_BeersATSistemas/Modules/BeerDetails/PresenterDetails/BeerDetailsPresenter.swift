//
//  BeerDetailsPresenter.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 18/03/22.
//


import Foundation


class BeerDetailsPresenter: BeerDetailsPresenterContract {
	weak var view: BeerDetailsViewContract?
	var interactor: BeerDetailsInteractorContract?
	var beerID: Int?
	var beer: BeerModel?
	
	
	init(beerID: Int) {
		self.beerID = beerID
	}
	
	
	func viewDidLoad() {
        interactor?.output = self
		view?.startActivity()
		buildDetailsViewModel()
	}
	
	
	func buildDetailsViewModel() {
		//print("beerID: \(String(describing: beerID)) (insideBeerDetailsPresenter)")
		interactor?.fetchBeer(withID: beerID ?? 1)
	}
	
	
	// MARK: - Deinit
	deinit {
		print("Deinit \(self)")
	}
}


// MARK: - Extension: BeerDetailsInteractorOutputContract
extension BeerDetailsPresenter: BeerDetailsInteractorOutputContract {
	func didFetch(beer: [BeerModel]) {
		self.beer = beer.first
		//print("Beer in didFetch (in BeerDetailsPresenter, InteractorOutputContract): \(String(describing: self.beer))")
		
		let beerViewModel = self.beer!.toDetailsViewModel
		//print("BeerViewModel: \(String(describing: beerViewModel))")
		
		view?.configure(with: beerViewModel)
		view?.stopAndHideActivity()
	}
	
	
	func fetchDidFail(error: String) {
		print("Error Fetching BeerID: \(error)")
	}
}
