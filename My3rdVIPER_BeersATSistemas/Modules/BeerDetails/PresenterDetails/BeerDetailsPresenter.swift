//
//  BeerDetailsPresenter.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 18/03/22.
//


import Foundation
import CoreData
import UIKit


class BeerDetailsPresenter: BeerDetailsPresenterContract {
	weak var view: BeerDetailsViewContract?
	var interactor: BeerDetailsInteractorContract?
	var beerID: Int?
	var beer: BeerModel?
		
	var favBeerImg: Data?
	
	init(beerID: Int) {
		self.beerID = beerID
	}
	
	
	func viewDidLoad() {
		interactor?.output = self
		view?.startActivity()
		buildDetailsViewModel()
	}
	
	
	func buildDetailsViewModel() {
		//print("beerID: \(String(describing: beerID)) (insideBeerDetailsPresenter)")
		interactor?.fetchBeer(withID: beerID ?? 1)
	}
	
	
	func saveBeerButtonPressed(viewModel: BeerDetailsViewModel) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		
		// MARK: -------------------Get Image to save (Start)-------------------
		guard let imgURL = viewModel.beerDetailsimageURL else { return }
				
		//  -------------------Get Image to save (End)-------------------
				
		
		// Check if wanted beer is already in the favorite list
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteBeer")
		request.returnsObjectsAsFaults = false
		request.predicate = NSPredicate(format: "favBeerID == %d", viewModel.beerDetailsID)  // If beerID is already in Favorite Beer list, it won't be saved again
				
		do {
			// Just checking if the beer to save is already in the favorites list according to the request.predicate
			let results = try context.fetch(request)
			
			// If the result is 0, then the beer is NOT YET in the favorite list and can be saved in it
			if results.count == 0 {
				print("results.count: \(results.count) (should be 0), therefore: this beer can be saved in the list of favorites since it is not duplicated")
				
				let task = URLSession.shared.dataTask(with: imgURL) { imgData, imgResponse, imgError in
					if imgError != nil {
						print("Error downloading the Beer Image")
						return
					}
					
					guard let imgData = imgData else { return }
					
					self.favBeerImg = imgData
					
					// Save new Favorite Beer
					let favBeer = NSEntityDescription.insertNewObject(forEntityName: "FavoriteBeer", into: context)
					favBeer.setValue(viewModel.beerDetailsID, forKey: "favBeerID")
					favBeer.setValue(viewModel.beerDetailsName, forKey: "favBeerName")
					favBeer.setValue(viewModel.beerDetailsDescription, forKey: "favBeerDescription")
					favBeer.setValue(self.favBeerImg, forKey: "favBeerImage")
					
					do {
						try context.save()
					} catch {
						print("Error trying to save values inside the URLSession")
					}
					
					print("Beer \(viewModel.beerDetailsName) Successfully saved in favorites!")
					DispatchQueue.main.async {
						self.view?.showBeerSavedSuccessfullyMsg()
					}
					
					print("-------------------")
				}
				
				task.resume()
				
				// Save new Favorite Beer
				//let favBeer = NSEntityDescription.insertNewObject(forEntityName: "FavoriteBeer", into: context)
//				favBeer.setValue(viewModel.beerDetailsID, forKey: "favBeerID")
//				favBeer.setValue(viewModel.beerDetailsName, forKey: "favBeerName")
//				favBeer.setValue(viewModel.beerDetailsDescription, forKey: "favBeerDescription")
//				favBeer.setValue(favBeerImg, forKey: "favBeerImage")

//				try context.save()
//				print("Beer \(viewModel.beerDetailsName) Successfully saved in favorites!")
//				view?.showBeerSavedSuccessfullyMsg()
//				print("-------------------")
			} else {
				for result in results as! [NSManagedObject] {
					//guard let savedFavBeerID = result.value(forKey: "favBeerID") as? Int16 else { return }
					//guard let savedFavBeerName = result.value(forKey: "favBeerName") as? String else { return }
					//guard let savedFavBeerDescription = result.value(forKey: "favBeerDescription") as? String else { return }
					
					print("BEER ALREADY IN FAVORITES!!!!")
					print("results.count: \(results.count) (should be more than 0), hence this beer CAN NOT be saved in the list of favorites since it's duplicated")
					print("The fav beerID in result is: \(result.value(forKey: "favBeerID") as! Int16)")
					print("The fav beerName in result is: \(result.value(forKey: "favBeerName") as? String ?? "Beer without Name")")
					print("The fav beerDescription in result is: \(result.value(forKey: "favBeerDescription") as? String ?? "No Description Available")")
					print("-------------------")
					view?.showBeerCannotBeSavedMsg()
				}
			}
		} catch {
			print("Error requesting the list of favorite beers")
		}
		
		print("-------------------")
		print("The saved context: \(context)")
	}
	
	
	// MARK: - Deinit
	deinit {
		print("Deinit \(self)")
	}
}


// MARK: - Extension: BeerDetailsInteractorOutputContract
extension BeerDetailsPresenter: BeerDetailsInteractorOutputContract {
	func didFetch(beer: [BeerModel]) {
		self.beer = beer.first
		//print("Beer in didFetch (in BeerDetailsPresenter, InteractorOutputContract): \(String(describing: self.beer))")
		
		guard let tempBeer = self.beer else { return }
		
		let beerViewModel = tempBeer.toDetailsViewModel
		//print("BeerViewModel: \(String(describing: beerViewModel))")
		
		view?.configure(with: beerViewModel)
		view?.stopAndHideActivity()
	}
	
	
	func fetchDidFail(error: String) {
		print("Error Fetching BeerID: \(error)")
	}
}
