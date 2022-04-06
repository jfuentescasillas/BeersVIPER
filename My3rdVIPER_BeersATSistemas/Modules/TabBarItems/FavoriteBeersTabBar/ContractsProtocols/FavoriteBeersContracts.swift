//
//  FavoriteBeersContracts.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 01/04/22.
//


import UIKit


// MARK: - View Contract/Protocol
protocol FavoriteBeersTableViewContract: UIViewController {
	var presenter: FavoriteBeersTablePresenterContract? { get set }
		
	func reloadData()
	/*func startActivity()
	func stopAndHideActivity()
	func searchBeerIsActive()
	func showEmptyResultsLabel()*/
}


// MARK: - Presenter Contract/Protocol
protocol FavoriteBeersTablePresenterContract: AnyObject {
	var view: FavoriteBeersTableViewContract? { get set }
	var numOfFavBeers: Int { get }
	
	func viewDidLoad()  // This one tells the Presenter that all is ready to work
	func cellViewModel(at indexPath: IndexPath) -> FavoriteBeer
	
	func deleteFavBeer(at indexPath: IndexPath)
	/*var interactor: BeerCollectionInteractorContract? { get set }
	var wireframe: BeerCollectionWireframeContract? { get set }
	 
	var numBeers: Int { get }
		
	func cellViewModel(at indexPath: IndexPath) -> BeerCollectionViewCellViewModel
	func didSelectItem(at indexPath: IndexPath)
	func fetchNextItems()
	func fetchSearchedItems(searchedName: String)
	func resetButtonPressed()*/
}
