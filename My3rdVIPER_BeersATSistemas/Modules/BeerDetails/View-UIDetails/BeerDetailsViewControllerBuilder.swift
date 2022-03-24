//
//  BeerDetailsViewControllerBuilder.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 17/03/22.
//


import UIKit


class BeerDetailsViewControllerBuilder {
	func build(beerID: Int) -> UIViewController {
		print("BeerID: \(beerID) (inside DetailsVCBuilder)")
        
		let viewController = BeerDetailsViewController.createFromStoryboard()
		let presenter = BeerDetailsPresenter(beerID: beerID)
		let interactor = BeerDetailsInteractor()
		
        viewController.presenter = presenter//buildPresenter(beerID: beerID)
        viewController.configure()
		presenter.view = viewController
		presenter.interactor = interactor
		
		return viewController
	}
	
	
//	private func buildPresenter(beerID: Int) -> BeerDetailsPresenterContract {
//		return BeerDetailsPresenter(beerID: beerID)
//	}
}
