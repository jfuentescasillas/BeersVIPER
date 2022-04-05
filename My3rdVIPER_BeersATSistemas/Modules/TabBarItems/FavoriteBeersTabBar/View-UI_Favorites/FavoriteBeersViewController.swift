//
//  FavoriteBeersViewController.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 01/04/22.
//

import UIKit

class FavoriteBeersViewController: UIViewController, FavoriteBeersTableViewContract {	
	// MARK: - Properties
	var presenter: FavoriteBeersTablePresenterContract?
	
	
	// MARK: - Elements in Storyboard
	@IBOutlet weak var searchFavoriteBeer: UISearchBar!
	@IBOutlet weak var emptyFavoriteLabel: UILabel!
	

	// MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}


// MARK: - Extension: SearchBarDelegate
extension FavoriteBeersViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let searchedFavBeerName = searchBar.text else { return }
		
		if !searchedFavBeerName.isEmpty {
			print("Favorite Beer searched: \(searchedFavBeerName)")
		} else {
			print("Please insert a text to find a FAVORITE BEER")
		}
		
		DispatchQueue.main.async {
			searchBar.resignFirstResponder()
		}
	}
}
