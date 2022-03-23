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
		let viewControllers: [UIViewController] = [buildBeersCollection()]
		
		tabBarController.setViewControllers(viewControllers, animated: false)
		
		return tabBarController
	}
	
	
	// MARK: - Build Beers Collection View Controller
	private func buildBeersCollection() -> UINavigationController {
		let viewController = BeersCollectionViewControllerBuilder().build()
		viewController.title = "Beers List"
		
		let tabBarItem = UITabBarItem(title: "Beers", image: UIImage(named: "beerNavBarImage-29x29"), tag: 0)
		
		return buildNavigation(with: viewController, tabBarItem: tabBarItem)
	}
	
	
	// MARK: - Build Navigation Controller
	private func buildNavigation(with viewController: UIViewController, tabBarItem: UITabBarItem) -> UINavigationController {
		let navController = UINavigationController(rootViewController: viewController)
		navController.tabBarItem = tabBarItem
		
		return navController
	}
}
