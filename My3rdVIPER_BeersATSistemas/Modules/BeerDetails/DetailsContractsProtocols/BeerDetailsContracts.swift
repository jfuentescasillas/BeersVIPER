//
//  BeerDetailsContracts.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 17/03/22.
//


import UIKit


protocol BeerDetailsViewContract: UIViewController {
	var presenter: BeerDetailsPresenterContract? { get set }
	
	func configure(/*with beerDetailsViewModel: BeerDetailsViewModel?*/)
}


protocol BeerDetailsPresenterContract: AnyObject {
	var view: BeerDetailsViewContract? { get set }
	var interactor: BeerDetailsInteractorContract? { get set }
	var beerID: Int? { get set }
	
	func viewDidLoad()
	func buildDetailsViewModel() // -> BeerDetailsViewModel
}


protocol BeerDetailsInteractorContract: AnyObject {
	var output: BeerDetailsInteractorOutputContract? { get set }
	
	func fetchBeer(withID: Int)
}


protocol BeerDetailsInteractorOutputContract: AnyObject {
	func didFetch(beer: [BeerModel])
	func fetchDidFail(error: String)
}
