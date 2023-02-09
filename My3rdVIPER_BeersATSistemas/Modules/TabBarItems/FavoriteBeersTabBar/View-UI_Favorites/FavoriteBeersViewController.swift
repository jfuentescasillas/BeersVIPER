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
	
	var isSearching: Bool = false
	
	// MARK: - Elements in Storyboard
	@IBOutlet weak var resetSearchOutlet: UIBarButtonItem!
	@IBOutlet weak var searchFavoriteBeer: UISearchBar!
	@IBOutlet weak var favBeersTableView: UITableView!
	@IBOutlet weak var emptyFavoriteLabel: UILabel!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	

	// MARK: - Methods related to the PresenterContract
	func reloadData() {
		DispatchQueue.main.async {
			self.favBeersTableView.reloadData()
		}
	}
	
	
	// Activity Indicator Controllers
	func startActivity() {
		DispatchQueue.main.async {
			self.activityIndicator.startAnimating()
		}
	}
	
	
	func stopAndHideActivity() {
		DispatchQueue.main.async {
			self.activityIndicator.stopAnimating()
			self.activityIndicator.hidesWhenStopped = true
		}
	}
	
	
	// MARK: - Life cycle
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
						
		presenter?.viewDidLoad()
		initialValues()
	}
	
	
	// MARK: - Private Methods of this class
	private func initialValues() {
		if !isSearching {
			resetSearchOutlet.isEnabled = false
		} else {
			resetSearchOutlet.isEnabled = true
		}
			
		resetSearchOutlet.title 	   = "beersResetButtonTitle".localized
		searchFavoriteBeer.placeholder = "searchFavBeerPlaceholder".localized
		emptyFavoriteLabel.text 	   = "emptyFavoriteListTxt".localized
		
		registerNotifications()
		
		if presenter?.numOfFavBeers == 0 {
			DispatchQueue.main.async {
				self.favBeersTableView.isHidden  = true
				self.emptyFavoriteLabel.isHidden = false
			}
		} else {
			DispatchQueue.main.async {
				self.favBeersTableView.isHidden  = false
				self.emptyFavoriteLabel.isHidden = true
			}
		}
	}
	
	
	// MARK: - Action Buttons
	@IBAction func resetButtonPressed(_ sender: Any) {
		resetDefaultFavoriteBeers()
	}
	
	
	private func resetDefaultFavoriteBeers() {
		searchFavoriteBeer.text 	= ""
		resetSearchOutlet.isEnabled = false
		isSearching 				= false
		
		presenter?.viewDidLoad()
		presenter?.resetOrCancelButtonPressed()
	}
	
	
	// MARK: - Keyboard related Methods
	// Methods to Place Keyboard Under the CollectionView
	func registerNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	
	@objc func keyboardWillShow(notification: NSNotification) {
		guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
		
		favBeersTableView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
	}
	
	
	@objc func keyboardWillHide(notification: NSNotification) {
		favBeersTableView.contentInset.bottom = 0
	}
	
	
	// MARK: - Deinit
	deinit {
		print("Deinit \(self)")
	}
}


// MARK: - Extension: SearchBarDelegate
extension FavoriteBeersViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		resetSearchOutlet.isEnabled = true
		isSearching = true
		
		guard let searchedFavBeerName = searchBar.text else { return }
		
		if !searchedFavBeerName.isEmpty {
			presenter?.searchFavoriteBeer(withQuery: searchedFavBeerName)
		} else {
			showMessageAlert(title: "alertControllerInvalidQueryTitle".localized,
							 message: "alertControllerInvalidQueryMsg".localized)
		}
		
		DispatchQueue.main.async {
			searchBar.resignFirstResponder()
		}
	}
	
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		resetDefaultFavoriteBeers()
		presenter?.resetOrCancelButtonPressed()
		isSearching = false
		
		// This lines help to hide the keyboard once the cancel button was clicked
		DispatchQueue.main.async {
			searchBar.resignFirstResponder()
		}
	}
}


// MARK: - Extension: UITableViewDataSource
extension FavoriteBeersViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter?.numOfFavBeers ?? 0
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let viewModel = presenter?.cellViewModel(at: indexPath) else { return UITableViewCell() }		
		guard let favBeerCell = favBeersTableView.dequeueReusableCell(withIdentifier: "FavoriteBeerCell", for: indexPath) as? FavoriteBeersTableViewCell else { return UITableViewCell() }
		
		favBeerCell.configure(with: viewModel)
		
		return favBeerCell
	}
}


// MARK: - Extension: UITableViewDelegate
extension FavoriteBeersViewController: UITableViewDelegate {
	// Table Delegate methods to delete a row
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		return .delete
	}
	
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			favBeersTableView.beginUpdates()
			favBeersTableView.deleteRows(at: [indexPath], with: .fade)
			
			presenter?.deleteFavBeer(at: indexPath)
			favBeersTableView.endUpdates()
		}
	}
	
	
	// Cell is clicked
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		favBeersTableView.deselectRow(at: indexPath, animated: true)
		
		presenter?.didSelectItem(at: indexPath)
	}
}
