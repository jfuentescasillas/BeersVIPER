//
//  FavBeerDetailsViewController.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 08/04/22.
//


import UIKit


class FavBeerDetailsViewController: UIViewController, FavBeerDetailsViewContract {
	var presenter: FavBeerDetailsPresenterContract?
	
	// Elements in storyboard
	@IBOutlet weak var favBeerScrollView: UIScrollView!
	@IBOutlet weak var favBeerImage: UIImageView!
	@IBOutlet weak var favBeerDescriptionLbl: UILabel!
	@IBOutlet weak var favBeer1stBrewedLbl: UILabel!
	@IBOutlet weak var favBeerABVLbl: UILabel!
	@IBOutlet weak var favBeerTaglineLbl: UILabel!	
	@IBOutlet weak var favBeerFoodPairingLbl: UILabel!
	@IBOutlet weak var favBeerTipsLbl: UILabel!
	@IBOutlet weak var favBeerOrigGravLbl: UILabel!
	@IBOutlet weak var favBeerFinalGravLbl: UILabel!
	@IBOutlet weak var favBeerAttenLevelLbl: UILabel!
	@IBOutlet weak var favBeerSRMLbl: UILabel!
	@IBOutlet weak var favBeerEBCLbl: UILabel!
	@IBOutlet weak var favBeerIBULbl: UILabel!
	@IBOutlet weak var favBeerPhLbl: UILabel!
	@IBOutlet weak var favBeerContributedByLbl: UILabel!
	@IBOutlet weak var favBeerObservationsTextView: UITextView!
	@IBOutlet weak var saveObservationOutletBtn: UIButton!
	
	
	// MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

		registerNotifications()
		hideKeyboardWhenTappedAround()
		
		saveObservationOutletBtn.setTitle("favBeerSaveObservationButtonTitle".localized,
										  for: .normal)
		presenter?.viewDidLoad()
    }
	
	
	// MARK: - Methods related to View Contract/Protocol
	func configure(with favoriteBeer: FavoriteBeer) {
		//print("favoriteBeer: \(favoriteBeer) (inside FavBeerDetailsViewController) configure(with...)")
		title = favoriteBeer.favBeerName
		favBeerImage.image = UIImage(data: favoriteBeer.favBeerImage!)
		favBeerDescriptionLbl.text = favoriteBeer.favBeerDescription
		favBeer1stBrewedLbl.text = favoriteBeer.favBeer1stBrewed
		favBeerABVLbl.text = "\(favoriteBeer.favBeerABV)"
		favBeerTaglineLbl.text = favoriteBeer.favBeerTagline
		
		// ** Filling the Favorite Beer Food Pairing Label **
		var tempFoodPairing = [String]()
		
		for index in 0..<(favoriteBeer.favBeerFoodPairing?.count ?? 0) {
			let favBeerFoodPairingAux = "- " + (favoriteBeer.favBeerFoodPairing?[index] ?? "") + "\n"
			tempFoodPairing.append(favBeerFoodPairingAux)
		}
		
		 self.favBeerFoodPairingLbl.text = tempFoodPairing.joined(separator: "")
		// ** Finished the Filling of the Favorite Beer Food Pairing Label **
		
		self.favBeerTipsLbl.text = favoriteBeer.favBeerBrewerTips
		self.favBeerOrigGravLbl.text = "\(favoriteBeer.favBeerOrigGrav)"
		self.favBeerFinalGravLbl.text = "\(favoriteBeer.favBeerFinalGrav)"
		self.favBeerAttenLevelLbl.text = "\(favoriteBeer.favBeerAttenLvl)"
		self.favBeerSRMLbl.text = "\(favoriteBeer.favBeerSRM)"
		self.favBeerEBCLbl.text = "\(favoriteBeer.favBeerEBC)"
		self.favBeerIBULbl.text = "\(favoriteBeer.favBeerIBU)"
		self.favBeerPhLbl.text = "\(favoriteBeer.favBeerPh)"
		self.favBeerContributedByLbl.text = favoriteBeer.favBeerContributedBy
		self.favBeerObservationsTextView.text = favoriteBeer.favBeerComments
	}
	
	
	// MARK: - Action buttons
	@IBAction func saveObservationsActionButton(_ sender: Any) {
		guard let opinion = favBeerObservationsTextView.text else { return }
		
		presenter?.saveCommentsAndUpdateCoreData(beerOpinion: opinion)
	}
	
	
	// MARK: - Keyboard related Methods
	// Methods to Place Keyboard Under the CollectionView
	func registerNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	
	@objc func keyboardWillShow(notification: NSNotification) {
		guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
		
		favBeerScrollView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
	}
	
	
	@objc func keyboardWillHide(notification: NSNotification) {
		favBeerScrollView.contentInset.bottom = 0
	}
	
	
	// Methods to Hide keyboard when the user taps in the screen
	private func hideKeyboardWhenTappedAround() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
	}
	
	
	@objc func dismissKeyboard() {
		favBeerObservationsTextView.resignFirstResponder()  // also can be used: view.endEditing(true)
	}
	
	
	// MARK: - Deinit
	deinit {
		print("Deinit \(self)")
	}
}
