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
		
		guard let imgURL = viewModel.beerDetailsimageURL else { return }
		
		// Check if wanted beer is already in the favorite list
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteBeer")
		request.returnsObjectsAsFaults = false
		request.predicate = NSPredicate(format: "favBeerID == %d", viewModel.beerDetailsID)  // If beerID is already in Favorite Beer list, it won't be saved again
				
		do {
			// Just checking if the beer to save is already in the favorites list according to the request.predicate
			let results = try context.fetch(request)
			
			// If the result is 0, then the beer is NOT YET in the favorite list and can be saved in it
			if results.count == 0 {
				//print("results.count: \(results.count) (should be 0), therefore: this beer can be saved in the list of favorites since it is not duplicated")
				
				let task = URLSession.shared.dataTask(with: imgURL) { imgData, imgResponse, imgError in
					if imgError != nil {
						print("Error downloading the Beer Image")
						
						return
					}
					
					// Save new Favorite Beer details (usually string and numeric values)
					let favBeer = NSEntityDescription.insertNewObject(forEntityName: "FavoriteBeer", into: context)
					favBeer.setValue(viewModel.beerDetailsID, forKey: "favBeerID")
					favBeer.setValue(viewModel.beerDetailsName, forKey: "favBeerName")
					favBeer.setValue(viewModel.beerDetailsDescription, forKey: "favBeerDescription")
					favBeer.setValue(viewModel.beerDetails1stBrewed, forKey: "favBeer1stBrewed")
					favBeer.setValue(viewModel.beerDetailsAbv, forKey: "favBeerABV")
					favBeer.setValue(viewModel.beerDetailsTagline, forKey: "favBeerTagline")
					favBeer.setValue(viewModel.beerDetailsFoodPairing, forKey: "favBeerFoodPairing")
					favBeer.setValue(viewModel.beerDetailsBrewersTips, forKey: "favBeerBrewerTips")
					favBeer.setValue(viewModel.beerDetailsOrigGrav, forKey: "favBeerOrigGrav")
					favBeer.setValue(viewModel.beerDetailsFinalGrav, forKey: "favBeerFinalGrav")
					favBeer.setValue(viewModel.beerDetailsAttenuationLvl, forKey: "favBeerAttenLvl")
					favBeer.setValue(viewModel.beerDetailsSRM, forKey: "favBeerSRM")
					favBeer.setValue(viewModel.beerDetailsEBC, forKey: "favBeerEBC")
					favBeer.setValue(viewModel.beerDetailsIBU, forKey: "favBeerIBU")
					favBeer.setValue(viewModel.beerDetailsPH, forKey: "favBeerPh")
					favBeer.setValue(viewModel.beerDetailsContributedBy, forKey: "favBeerContributedBy")
					
					
					// Saving the image, which is Data. If some error occurs in the beerImage, the default placeholder will be shown in the cell along with all the data previously saved in favBeer.setValue(...)
					guard let imgData = imgData else { return }
					
					self.favBeerImg = imgData
					
					favBeer.setValue(self.favBeerImg, forKey: "favBeerImage")
					
					// Save everything
					do {
						try context.save()
					} catch {
						print("Error trying to save values inside the URLSession")
					}
					
					//print("Beer \(viewModel.beerDetailsName) Successfully saved in favorites!")
					DispatchQueue.main.async {
						self.view?.showBeerSavedSuccessfullyMsg()
					}
				}
				
				task.resume()
			} else {
				// In case it is needed, uncomment the lines below to check the values
				/*for result in results as! [NSManagedObject] {
					print("BEER ALREADY IN FAVORITES!!!!")
					print("results.count: \(results.count) (should be more than 0), hence this beer CAN NOT be saved in the list of favorites since it's duplicated")
					print("The fav beerID in result is: \(result.value(forKey: "favBeerID") as! Int16)")
					print("The fav beerName in result is: \(result.value(forKey: "favBeerName") as? String ?? "Beer without Name")")
					print("The fav beerDescription in result is: \(result.value(forKey: "favBeerDescription") as? String ?? "No Description Available")")
					print("-------------------")
				}*/
				
				// Beer already exists in the Database and message is displayed
				view?.showBeerCannotBeSavedMsg()
			}
		} catch {
			print("Error requesting the list of favorite beers (Inside BeerDetailsPresenter")
		}
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
		DispatchQueue.main.async {
			self.view?.showMessageAlert(title: "No Internet Connection", message: "It seems that your device has no internet connection, please try again later")
			self.view?.showNoInternetConnectionLabel()
		}
	}
}
