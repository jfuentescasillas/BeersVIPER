//
//  FavoriteBeersTablePresenter.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 01/04/22.
//


import UIKit
import CoreData


class FavoriteBeersTablePresenter: FavoriteBeersTablePresenterContract {
	// MARK: - Properties related to the PresenterContract
	weak var view: FavoriteBeersTableViewContract?
	var numOfFavBeers: Int {
		return favBeers.count
	}
	
	// Core Data
	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	lazy var context = appDelegate.persistentContainer.viewContext
	
	
	// MARK: Private Properties of the class
	private var favBeers = [FavoriteBeer]() {
		didSet {
			view?.reloadData()
		}
	}
	
	
	// MARK: - Methods related to the PresenterContract
	func viewDidLoad() {
		loadFavBeersData()
	}
	
	
	// MARK: - Create, Read, Update and Delete (CRUD) Data in CoreData
	// MARK: Load Data
	private func loadFavBeersData() {
		let request: NSFetchRequest<FavoriteBeer> = FavoriteBeer.fetchRequest() //NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteBeer")
		request.returnsObjectsAsFaults = true
	
		do {
			let results = try context.fetch(request)
						
			if results.count > 0 {
				// Assign the results found in favBeersArray
				favBeers = results
				
				/*print("FavBeers: \(favBeers)")
				print("---------------")*/
				
				// Just to check what is being saved
				/*for result in results as [NSManagedObject] {
					guard let savedFavBeerID = result.value(forKey: "favBeerID") as? Int16 else { return }
					guard let savedFavBeerName = result.value(forKey: "favBeerName") as? String else { return }
					guard let savedFavBeerDescription = result.value(forKey: "favBeerDescription") as? String else { return }
					
					print("The saved fav beer ID is: \(savedFavBeerID)")
					print("The saved fav beer Name is: \(savedFavBeerName)")
					print("The saved fav beer Description is: \(savedFavBeerDescription)")
					print("---------------(inside requestFavoriteBeers() at FavoriteBeersTablePresenter class)")
					
				}*/
			} else {
				print("No favorite beers in the list (inside requestFavoriteBeers() at FavoriteBeersTablePresenter class)")
			}
		} catch {
			print("Error requesting the list of favorite beers")
		}
	}
	
	
	// MARK: Delete Data
	func deleteFavBeer(at indexPath: IndexPath) {
		context.delete(favBeers[indexPath.row])  // This line goes first...
		favBeers.remove(at: indexPath.row)  //...Then this line goes next.
		
		do {
			try context.save()
		} catch {
			print("Error Deleting the Beer From Favorites")
		}
		
		/*print("FavBeers: \(favBeers) (after deleting one beer)")
		print("---------------")*/
	}
	
	
	// MARK: Search Data
	func searchFavoriteBeer(withQuery: String) {
		print("Favorite Beer searched: \(withQuery) (inside FavoriteBeersTablePresenter)")
	}
	
	// MARK: - Cell View Model
	func cellViewModel(at indexPath: IndexPath) -> FavoriteBeer {		
		return favBeers[indexPath.row]
	}
	
	
	// MARK: - Deinit
	deinit {
		print("Deinit \(self)")
	}
}
