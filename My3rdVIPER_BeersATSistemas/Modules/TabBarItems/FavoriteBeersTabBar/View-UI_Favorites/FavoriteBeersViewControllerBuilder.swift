//
//  FavoriteBeersViewControllerBuilder.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 01/04/22.
//


import UIKit


class FavoriteBeersViewControllerBuilder {
	func build() -> UIViewController {
		let viewController 		 = FavoriteBeersViewController.createFromStoryboard()
		let presenter 			 = FavoriteBeersTablePresenter()
		let wireframe 			 = FavoriteBeerTableWireframe()
		
		viewController.presenter = presenter
		
		presenter.view 			 = viewController
		presenter.wireframe 	 = wireframe
		
		wireframe.view 			 = viewController
		
		/*let interactor = BeersCollectionInteractor()
		interactor.beersProvider = NetworkBeersCollectionProvider()
		
		let wireframe = BeersCollectionWireframe()
		
		viewController.presenter = presenter
		
		presenter.view = viewController
		presenter.interactor = interactor
		presenter.wireframe = wireframe
		
		wireframe.view = viewController*/
		
		return viewController
	}
}
