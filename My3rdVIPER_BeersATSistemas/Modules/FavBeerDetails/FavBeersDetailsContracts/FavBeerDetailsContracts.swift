//
//  FavBeerDetailsContracts.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 08/04/22.
//


import UIKit


// MARK: - View Contract/Protocol
protocol FavBeerDetailsViewContract: UIViewController {
	var presenter: FavBeerDetailsPresenterContract? { get set }
	
	func configure(with favoriteBeer: FavoriteBeer)
	/*
	func startActivity()
	func stopAndHideActivity()
	func showBeerSavedSuccessfullyMsg()
	func showBeerCannotBeSavedMsg()
	func showNoInternetConnectionLabel()*/
}


// MARK: - Presenter Contract/Protocol
protocol FavBeerDetailsPresenterContract: AnyObject {
	var view: FavBeerDetailsViewContract? { get set }
	
	var favoriteBeer: FavoriteBeer? { get set }
	
	func viewDidLoad()
	/*var interactor: BeerDetailsInteractorContract? { get set }
	var beerID: Int? { get set }
	
	func buildDetailsViewModel()
	func saveBeerButtonPressed(viewModel: BeerDetailsViewModel)*/
}
