//
//  FavoriteBeersTablePresenter.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 01/04/22.
//


import UIKit
import CoreData


class FavoriteBeersTablePresenter: FavoriteBeersTablePresenterContract {
	// MARK: - Properties
	weak var view: FavoriteBeersTableViewContract?
	
	
	func viewDidLoad() {
		requestFavoriteBeers()
	}
	
	
	private func requestFavoriteBeers() {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteBeer")
		request.returnsObjectsAsFaults = false
	
		do {
			let results = try context.fetch(request)
			
			if results.count > 0 {
				for result in results as! [NSManagedObject] {
					guard let savedFavBeerID = result.value(forKey: "favBeerID") as? Int16 else { return }
					guard let savedFavBeerName = result.value(forKey: "favBeerName") as? String else { return }
					guard let savedFavBeerDescription = result.value(forKey: "favBeerDescription") as? String else { return }
					
					print("The saved fav beer ID is: \(savedFavBeerID)")
					print("The saved fav beer Name is: \(savedFavBeerName)")
					print("The saved fav beer Description is: \(savedFavBeerDescription)")
					print("---------------(inside requestFavoriteBeers() at FavoriteBeersTablePresenter class)")
				}
			} else {
				print("No favorite beers in the list (inside requestFavoriteBeers() at FavoriteBeersTablePresenter class)")
			}
		} catch {
			print("Error requesting the list of favorite beers")
		}
	}
	
	
	// MARK: - Deinit
	deinit {
		print("Deinit \(self)")
	}
}
