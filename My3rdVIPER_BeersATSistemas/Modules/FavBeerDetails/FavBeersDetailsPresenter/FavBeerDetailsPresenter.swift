//
//  FavBeerDetailsPresenter.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 08/04/22.
//

import Foundation


class FavBeerDetailsPresenter: FavBeerDetailsPresenterContract {
	// MARK: - Properties related to Presenter Contract/Protocol
	var view: FavBeerDetailsViewContract?
	
	var favoriteBeer: FavoriteBeer?
	
	init(favoriteBeer: FavoriteBeer) {
		self.favoriteBeer = favoriteBeer
	}
	
	
	// MARK: - Methods related to Presenter Contract/Protocol
	func viewDidLoad() {
		//print("FavoriteBeer: \(favoriteBeer!) (inside FavBeerDetailsPresenter")
		
		guard let favoriteBeer = favoriteBeer else { return }

		configureView(with: favoriteBeer)
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
