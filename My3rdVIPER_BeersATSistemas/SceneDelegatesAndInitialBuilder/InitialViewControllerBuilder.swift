//
//  InitialViewControllerBuilder.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 14/03/22.
//


import UIKit


class InitialViewControllerBuilder {
	public func build() -> UIViewController {
		let tabBarController = UITabBarController()
		let viewControllers: [UIViewController] = [buildBeersCollection(), buildFavoriteBeersTable()]
		
		tabBarController.setViewControllers(viewControllers, animated: false)
		
		return tabBarController
	}
	
	
	// MARK: - Build View Controllers
	/// Build Beers Collection View Controller
	private func buildBeersCollection() -> UINavigationController {
		let viewController = BeersCollectionViewControllerBuilder().build()
		viewController.title = "Beers List"
		
		let tabBarItem = UITabBarItem(title: "Beers", image: UIImage(named: "beerNavBarImage-29x29"), tag: 0)
		
		return buildNavigation(with: viewController, tabBarItem: tabBarItem)
	}
	
	
	/// Build Favorite Beers Table View Controller
	private func buildFavoriteBeersTable() -> UINavigationController {
		let viewController = FavoriteBeersViewControllerBuilder().build()
		viewController.title = "Favorite Beers"
		
		let tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star.fill"), tag: 1)
		
		return buildNavigation(with: viewController, tabBarItem: tabBarItem)
	}
	
	
	// MARK: - Build Navigation Controller
	private func buildNavigation(with viewController: UIViewController, tabBarItem: UITabBarItem) -> UINavigationController {
		let navController = UINavigationController(rootViewController: viewController)
		navController.tabBarItem = tabBarItem
		
		return navController
	}
	
	
	// MARK: - Deinit
	deinit {
		print("Deinit \(self)")
	}
}
