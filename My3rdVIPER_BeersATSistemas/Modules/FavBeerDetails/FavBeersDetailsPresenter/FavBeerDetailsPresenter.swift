//
//  FavBeerDetailsPresenter.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 08/04/22.
//

import UIKit
import CoreData


class FavBeerDetailsPresenter: FavBeerDetailsPresenterContract {
	// MARK: - Properties related to Presenter Contract/Protocol
	weak var view: FavBeerDetailsViewContract?
	
	var favoriteBeer: FavoriteBeer?
	
	init(favoriteBeer: FavoriteBeer) {
		self.favoriteBeer = favoriteBeer
	}
	
	
	// MARK: - Methods related to Presenter Contract/Protocol
	func viewDidLoad() {
		guard let favoriteBeer = favoriteBeer else { return }

		configureView(with: favoriteBeer)
	}
	
	
	func saveCommentsAndUpdateCoreData(beerOpinion: String) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context 	= appDelegate.persistentContainer.viewContext
		
		guard let favoriteBeer = favoriteBeer else { return }
		
		favoriteBeer.setValue(beerOpinion, forKey: "favBeerComments")
		
		// Save everything
		do {
			try context.save()
		} catch {
			print("Error trying to save favorite beer Comment inside FavBeerDetailsPresenter")
		}
		
		view?.showMessageAlert(title: "alertControllerOpinionSavedTitle".localized,
							   message: "alertControllerOpinionSavedMsg".localized)
	}
	
	
	// MARK: - Private methods
	private func configureView(with favoriteBeer: FavoriteBeer) {
		view?.configure(with: favoriteBeer)
	}
	
	
	// MARK: - Deinit
	deinit {
		print("Deinit \(self)")
	}
}
