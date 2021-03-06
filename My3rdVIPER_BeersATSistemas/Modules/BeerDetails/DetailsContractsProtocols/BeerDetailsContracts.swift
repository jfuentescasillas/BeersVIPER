//
//  BeerDetailsContracts.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 17/03/22.
//


import UIKit


// MARK: - View Contract/Protocol
protocol BeerDetailsViewContract: UIViewController {
	var presenter: BeerDetailsPresenterContract? { get set }
	
	func configure(with beerDetailsViewModel: BeerDetailsViewModel?)
	func startActivity()
	func stopAndHideActivity()
	func showBeerSavedSuccessfullyMsg()
	func showBeerCannotBeSavedMsg()
	func showNoInternetConnectionLabel()
}


// MARK: - Presenter Contract/Protocol
protocol BeerDetailsPresenterContract: AnyObject {
	var view: BeerDetailsViewContract? { get set }
	var interactor: BeerDetailsInteractorContract? { get set }
	var beerID: Int? { get set }
	
	func viewDidLoad()
	func buildDetailsViewModel()
	func saveBeerButtonPressed(viewModel: BeerDetailsViewModel)
}


// MARK: - Interactor Contracts/Protocols
protocol BeerDetailsInteractorContract: AnyObject {
	var output: BeerDetailsInteractorOutputContract? { get set }
	var beerDetailsProvider: BeerDetailsProviderContract? { get set }
	
	func fetchBeer(withID: Int)
}


protocol BeerDetailsInteractorOutputContract: AnyObject {
	func didFetch(beer: [BeerModel])
	func fetchDidFail(error: String)
}


// MARK: - Provider Contracts/Protocols
protocol BeerDetailsProviderContract {
	func getBeerDetails(beerID: Int, _ completion: @escaping(Result<[BeerModel], BeersCollectionProviderError>) -> ())
}
