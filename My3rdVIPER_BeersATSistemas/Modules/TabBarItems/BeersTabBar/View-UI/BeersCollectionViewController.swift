//
//  BeersCollectionViewController.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 14/03/22.
//


import UIKit


class BeersCollectionViewController: UIViewController, BeersCollectionViewContract {
	// MARK: - Properties
	var presenter: BeerCollectionPresenterContract?
	
	private var cellLayout: UICollectionViewFlowLayout {
		let numberOfColumns: CGFloat = 1  // For this app in particular, use the value of 1, otherwise reconfigure the cell
		let layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = 10  // Minimal space between cells
		layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 30, right: 10)  // margins of each section
		
		// width = (screen's width / number of columns in screen) - (space between cells / 2) - (the left section inset)
		let screenWidth = (beersCollectionView.frame.width / numberOfColumns) - (layout.minimumInteritemSpacing / 2) - layout.sectionInset.left
		let screenHeight = (screenWidth/3) + (screenWidth/5) - (screenWidth/6.5)
		
//		print("Width of Screen: \(screenWidth)")
//		print("Height of Screen: \(round(screenHeight))")
		
		// Using screenWidth-5 because the console shows a message about a mismatching width (the calculated width is bigger than the phone's width), and 5 is the minimum number to make that message disappear
		layout.itemSize = CGSize(width: screenWidth-5, height: round(screenHeight))
		
		return layout
	}
		
	// Elements of Storyboard
	@IBOutlet weak var resetBeerSearchButtonItem: UIBarButtonItem!
	@IBOutlet weak var beersSearchBar: UISearchBar!
	@IBOutlet weak var beersCollectionView: UICollectionView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var emptyResultsLabel: UILabel!
	
		
	// MARK: - Life cycle
	override func viewDidLoad() {
        super.viewDidLoad()
		
		emptyResultsLabel.isHidden = true
		
		setSearchBar()
		registerNotifications()
		hideKeyboardWhenTappedAround()
		presenter?.viewDidLoad()
    }
	
	
	// MARK: - Contract/Protocol methods
	func reloadData() {
		DispatchQueue.main.async {
			self.beersCollectionView.reloadData()
		}
	}
	
	
	// Activity Indicator Controllers
	func startActivity() {
		DispatchQueue.main.async {
			self.activityIndicator.startAnimating()
			self.beersCollectionView.isHidden = true
		}
	}
	
	
	func stopAndHideActivity() {
		DispatchQueue.main.async {
			self.activityIndicator.stopAnimating()
			self.activityIndicator.hidesWhenStopped = true
			
			self.beersCollectionView.isHidden = false
			// layoutIfNeeded() is needed in order to see the elements of the collection view in the last cell, otherwise, when the pagination is done, the collection view shows the requested items from the beginning (array's 1st item), and not from the array's last item (which is what is wanted)
			self.beersCollectionView.layoutIfNeeded()
			
			self.emptyResultsLabel.isHidden = true
		}
	}
	
	
	// MARK: - LayoutSubviews
	// Writes the layout subviews programmed after didLoad
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		beersCollectionView.setCollectionViewLayout(cellLayout, animated: false)
	}
	
	
	// MARK: - SearchBar config
	private func setSearchBar() {
		resetBeerSearchButtonItem.isEnabled = false
		beersSearchBar.delegate = self
		beersSearchBar.placeholder = "Search for a beer..."
	}
	
	
	// MARK: - Keyboard related Methods
	// Methods to Place Keyboard Under the CollectionView
	func registerNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	
	@objc func keyboardWillShow(notification: NSNotification) {
		guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
		
		beersCollectionView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
	}
	
	
	@objc func keyboardWillHide(notification: NSNotification) {
		beersCollectionView.contentInset.bottom = 0
	}
	
	
	// Methods to Hide keyboard when the user taps in the screen
	private func hideKeyboardWhenTappedAround() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
	}
	
	
	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
	
	
	// MARK: - Show Empty Search Results label
	func showEmptyResultsLabel() {
		DispatchQueue.main.async {
			self.activityIndicator.stopAnimating()
			self.activityIndicator.hidesWhenStopped = true
			
			self.beersCollectionView.isHidden = true
			
			self.emptyResultsLabel.isHidden   = false
			self.emptyResultsLabel.text = "There were no results for the beer you requested. Please try with another name."
		}
	}
	
		
	// MARK: - Action Buttons
	@IBAction func resetBeerSearchButtonAction(_ sender: Any) {
		presenter?.resetButtonPressed()
		beersSearchBar.text = ""
		resetBeerSearchButtonItem.isEnabled = false
	}
}


// MARK: - Extension: UICollectionViewDataSource
extension BeersCollectionViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return presenter?.numBeers ?? 0
	}
	
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let viewModel = presenter?.cellViewModel(at: indexPath), let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BeerCollectionViewCell", for: indexPath) as? BeerCollectionViewCell else {
			fatalError("Error creating BeerCollectionViewCell")
		}
				
		cell.configure(with: viewModel)
		
		return cell
	}
}


// MARK: - Extension: UICollectionViewDelegate
extension BeersCollectionViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		presenter?.didSelectItem(at: indexPath)
	}
	
	
	// MARK: - Pagination
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		let offsetY 		= scrollView.contentOffset.y     // y coordinate (up and down)
		let contentHeight 	= scrollView.contentSize.height  // The entire scrollview, if there are 5,000 items, it will be very tall
		let height 			= scrollView.frame.size.height   // Screen's height
		
		if (offsetY > (contentHeight - height)) {
			presenter?.fetchNextItems()
		}
	}
}


// MARK: - Extension: UISearchBarDelegate
extension BeersCollectionViewController: UISearchBarDelegate {
	// MARK: UISearchBarDelegate Methods
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		beersSearchBar.text = ""
				
		// This lines help to hide the keyboard once the cancel button was clicked
		DispatchQueue.main.async {
			searchBar.resignFirstResponder()
		}
	}
	
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		// Can't make searches if the text is empty or if it has only one blank space
		if searchBar.text == "" || searchBar.text == " " {
			return
		}
		
		// Use of guard var instead of guard let since its value will later change
		guard var searchedBeer = searchBar.text else { return }
		
		// The search can only contain numbers and/or digits, otherwise it fails.
		if searchedBeer.isAlphanumeric {
			// If the query has white spaces, it is replaced by %20, (which is the hexadecimal value for the white space used in an encoded URL)
			// Example: if the query is "alpha dog", it will be changed to "alpha%20dog", which is a valid encoded URL address for the API
			searchedBeer = searchedBeer.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
			presenter?.fetchSearchedItems(searchedName: searchedBeer)
		} else {
			showMessageAlert(title: "Invalid Text Input", message: "Your search can only contain numbers/digits and/or spaces, please try again with a valid format.")
		}
		
		// This lines help to hide the keyboard once the search was requested
		DispatchQueue.main.async {
			searchBar.resignFirstResponder()
		}
	}
	
	
	// MARK: - Custom Methods related to the searchBar (not part of UISearchBarDelegate)
	// Reset button is active when a search has been made
	func searchBeerIsActive() {
		resetBeerSearchButtonItem.isEnabled = true
	}
}
