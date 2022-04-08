//
//  FavoriteBeerDetailsViewControllerBuilder.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 08/04/22.
//


import UIKit


class FavoriteBeerDetailsViewControllerBuilder {
	func build(favoriteBeer: FavoriteBeer) -> UIViewController {
		let viewController 			   = FavBeerDetailsViewController.createFromStoryboard()
		let presenter 				   = FavBeerDetailsPresenter(favoriteBeer: favoriteBeer)
		
		viewController.presenter 	   = presenter		
		presenter.view 				   = viewController

		/*let interactor 				   = FavBeerDetailsInteractor()
		interactor.beerDetailsProvider = NetworkBeerDetailsProvider()
		
		
		presenter.interactor 		   = interactor
		*/
		return viewController
	}
}
