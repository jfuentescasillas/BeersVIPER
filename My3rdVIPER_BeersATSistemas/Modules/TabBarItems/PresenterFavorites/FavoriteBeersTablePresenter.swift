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
	var wireframe: FavoriteBeerTableWireframeContract?
	
	var numOfFavBeers: Int {
		return favBeers.count
	}
		
	// Core Data Properties
	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	lazy var context = appDelegate.persistentContainer.viewContext
	
	// MARK: - Private Properties of the class
	private var favBeers = [FavoriteBeer]() {
		didSet {
			view?.reloadData()
		}
	}
	private var isSearching: Bool = false
	
	
	// MARK: - Methods related to the PresenterContract
	func viewDidLoad() {
		view?.startActivity()
		loadFavBeersData()
	}
	
	
	// MARK: - Create, Read, Update and Delete (CRUD) Data in CoreData
	// MARK: Load Data
	private func loadFavBeersData(withRequest: NSFetchRequest<FavoriteBeer> = FavoriteBeer.fetchRequest()) {
		withRequest.returnsObjectsAsFaults = true
	
		do {
			let results = try context.fetch(withRequest)
						
			if results.count > 0  {
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
			} else if isSearching {
				view?.showMessageAlert(title: "No Beers Found!", message: "Your favorite list of beers does not have any beer with the requested query, please try again with another name.")
			} else {
				print("Initial status with an empty list.")
			}
		} catch {
			print("Error requesting the list of favorite beers")
		}
		
		view?.stopAndHideActivity()
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
	}
	
	
	// MARK: Search Data
	func searchFavoriteBeer(withQuery: String) {
		isSearching = true
		let searchRequest: NSFetchRequest<FavoriteBeer> = FavoriteBeer.fetchRequest()
		searchRequest.predicate = NSPredicate(format: "favBeerName CONTAINS[cd] %@", withQuery)
		
		loadFavBeersData(withRequest: searchRequest)
	}
	
	
	func resetOrCancelButtonPressed() {
		isSearching = false
	}
	
	
	// MARK: - Cell View Model
	func cellViewModel(at indexPath: IndexPath) -> FavoriteBeer {		
		return favBeers[indexPath.row]
	}
	
	
	// MARK: - Did Select Item
	func didSelectItem(at indexPath: IndexPath) {
		/*let beerName: String = favBeers[indexPath.row].favBeerName!
		print("The BeerName of the clicked cell is: \(beerName) (in FavoriteBeersTablePresenter)")*/
		
		wireframe?.navigate(to: favBeers[indexPath.row])
		/*print("BeerID: \(beerID) (in BeersCollectionPresenter)")*/
		
		//wireframe?.navigate(to: beerID)
	}
	
	// MARK: - Deinit
	deinit {
		print("Deinit \(self)")
	}
}
