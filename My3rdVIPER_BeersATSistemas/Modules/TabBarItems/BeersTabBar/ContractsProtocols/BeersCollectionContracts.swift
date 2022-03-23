//
//  BeersCollectionContracts.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 14/03/22.
//


import UIKit


// MARK: - View Contract/Protocol
protocol BeersCollectionViewContract: UIViewController {
	var presenter: BeerCollectionPresenterContract? { get set }
	
	func reloadData()
}


// MARK: - Presenter Contract/Protocol
protocol BeerCollectionPresenterContract: AnyObject {
	var view: BeersCollectionViewContract? { get set }
	var interactor: BeerCollectionInteractorContract? { get set }
	var wireframe: BeerCollectionWireframeContract? { get set }
	 
	var numBeers: Int { get }
	
	func viewDidLoad()  // This one tells the Presenter that all is ready to work
	func cellViewModel(at indexPath: IndexPath) -> BeerCollectionViewCellViewModel
	func didSelectItem(at indexPath: IndexPath)
}


// MARK: - Interactor Contract/Protocol
protocol BeerCollectionInteractorContract: AnyObject {
	var output: BeerCollectionInteractorOutputContract? { get set }
	
	func fetchBeers()
}


// This Protocol will return the requested items (in this case: Beers)
protocol BeerCollectionInteractorOutputContract: AnyObject {
	func didFetch(beers: [BeerModel])
	func fetchDidFail(error: String)
}


// MARK: - Wireframe/Router Contract/Protocol
protocol BeerCollectionWireframeContract {
	var view: UIViewController? { get set }
	
	func navigate(to beerID: Int)
}