//
//  BeerDetailsViewControllerBuilder.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 17/03/22.
//


import UIKit


class BeerDetailsViewControllerBuilder {
	func build(beerID: Int) -> UIViewController {
		let viewController 			   = BeerDetailsViewController.createFromStoryboard()
		let presenter 				   = BeerDetailsPresenter(beerID: beerID)
		let interactor 				   = BeerDetailsInteractor()
		interactor.beerDetailsProvider = NetworkBeerDetailsProvider()
		
        viewController.presenter 	   = presenter
		
		presenter.view 				   = viewController
		presenter.interactor 		   = interactor
		
		return viewController
	}
}
