//
//  BeersCollectionViewControllerBuilder.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 15/03/22.
//


import UIKit


class BeersCollectionViewControllerBuilder {
	func build() -> UIViewController {
		let viewController = BeersCollectionViewController.createFromStoryboard()
		let presenter = BeersCollectionPresenter()
		let interactor = BeersCollectionInteractor()
		let wireframe = BeersCollectionWireframe()
		
		viewController.presenter = presenter
		
		presenter.view = viewController
		presenter.interactor = interactor
		presenter.wireframe = wireframe
        
		wireframe.view = viewController
		
		return viewController
	}
}
