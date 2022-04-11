//
//  FavoriteBeerTableWireframe.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 08/04/22.
//

import UIKit


class FavoriteBeerTableWireframe: FavoriteBeerTableWireframeContract {
	weak var view: UIViewController?
	
	
	func navigate(to favoriteBeer: FavoriteBeer) {
		DispatchQueue.main.async {
			//print("favoriteBeer: \(favoriteBeer) (inside FavoriteBeerTableWireframe)")
			let viewController = FavoriteBeerDetailsViewControllerBuilder().build(favoriteBeer: favoriteBeer)
						
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
