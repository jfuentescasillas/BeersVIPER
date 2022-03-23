//
//  BeersCollectionWireframe.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 17/03/22.
//


import UIKit


class BeersCollectionWireframe: BeerCollectionWireframeContract {
	weak var view: UIViewController?
	
	
	func navigate(to beerID: Int) {
		DispatchQueue.main.async {
			print("BeerID: \(beerID) (inside BeersCollectionWireframe)")
			let viewController = BeerDetailsViewControllerBuilder().build(beerID: beerID)
						
			if let navigationController = self.view?.navigationController {
				navigationController.pushViewController(viewController, animated: true)
			} else {
				self.view?.present(viewController, animated: true)
			}			
		}
	}
	
	
	deinit {
		print("Deinit \(self)")
	}
}
