//
//  BeerDetailsViewController.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 17/03/22.
//


import UIKit


struct BeerDetailsViewModel {
	let beerDetailsID: Int
	let beerDetailsName: String
	let beerDetailsDescription: String?
	let beerDetails1stBrewed: String?
	let beerDetailsTagline: String?
	let beerDetailsimageURL: URL?
	let beerDetailsAbv: Double?
	let beerDetailsPH: Double?
	let beerDetailsOrigGrav: Double?
	let beerDetailsFinalGrav: Int?
	let beerDetailsAttenuationLvl: Double?
	let beerDetailsSRM: Double?
	let beerDetailsEBC: Double?
	let beerDetailsIBU: Double?
	let beerDetailsFoodPairing: [String]?
	let beerDetailsBrewersTips: String?
	let beerDetailsContributedBy: String  // ContributedBy
}


class BeerDetailsViewController: UIViewController, BeerDetailsViewContract {
	// MARK: - Properties related to the ViewContract
	var presenter: BeerDetailsPresenterContract?
	
	// MARK: - Elements in Storyboard
	@IBOutlet weak var beerImageDetailsImg: UIImageView!
	@IBOutlet weak var beerDescriptionDetailsLbl: UILabel!
	@IBOutlet weak var firstBrewDetailsLbl: UILabel!
	@IBOutlet weak var abvDetailsLbl: UILabel!
	@IBOutlet weak var beerTaglineDetailsLbl: UILabel!
	@IBOutlet weak var foodPairingDetailsLbl: UILabel!
	@IBOutlet weak var brewersTipsDetailsLbl: UILabel!
	@IBOutlet weak var originalGravityDetailsLbl: UILabel!
	@IBOutlet weak var finalGravityDetailsLbl: UILabel!
	@IBOutlet weak var attenuationLevelDetailsLbl: UILabel!
	@IBOutlet weak var srmDetailsLbl: UILabel!
	@IBOutlet weak var ebcDetailsLbl: UILabel!
	@IBOutlet weak var ibuDetailsLbl: UILabel!
	@IBOutlet weak var phDetailsLbl: UILabel!
	@IBOutlet weak var contributionDetailsLbl: UILabel!
	
	
	// MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
		
		presenter?.viewDidLoad()		
    }
	
	
	// MARK: - Methods related to the ViewContract	
	func configure(with beerDetailsViewModel: BeerDetailsViewModel?) {
		guard let detailsViewModel = beerDetailsViewModel else { return }
		
		print("----------------")
		print("DetailsViewModel (inside BeerDetailsViewController, at configure(with...): \n \(detailsViewModel) ")
		
		DispatchQueue.main.async {
			self.title = detailsViewModel.beerDetailsName
			
			guard let beerURL = detailsViewModel.beerDetailsimageURL else { return }
			
			self.beerImageDetailsImg.downloaded(from: beerURL)
			self.beerDescriptionDetailsLbl.text = detailsViewModel.beerDetailsDescription
			self.firstBrewDetailsLbl.text 		= detailsViewModel.beerDetails1stBrewed
			self.abvDetailsLbl.text 			= "\(String(describing: detailsViewModel.beerDetailsAbv ?? 4.5))"
			self.beerTaglineDetailsLbl.text 	= detailsViewModel.beerDetailsTagline
			
			// ** Filling the Food Pairing Label **
			var tempFoodPairing = [String]()
			
			for index in 0..<(detailsViewModel.beerDetailsFoodPairing?.count ?? 0) {
				let favBeerFoodPairingAux = "- " + (detailsViewModel.beerDetailsFoodPairing?[index] ?? "") + "\n"
				tempFoodPairing.append(favBeerFoodPairingAux)
			}
			
			 self.foodPairingDetailsLbl.text = tempFoodPairing.joined(separator: "")
			// ** Finished the Filling of the Food Pairing Label **
			
			self.brewersTipsDetailsLbl.text 	 = detailsViewModel.beerDetailsBrewersTips
			self.originalGravityDetailsLbl.text  = "\(detailsViewModel.beerDetailsOrigGrav ?? 0)"
			self.finalGravityDetailsLbl.text 	 = "\(detailsViewModel.beerDetailsFinalGrav ?? 0)"
			self.attenuationLevelDetailsLbl.text = "\(detailsViewModel.beerDetailsAttenuationLvl ?? 0)"
			self.srmDetailsLbl.text 		 	 = "\(detailsViewModel.beerDetailsSRM ?? 0)"
			self.ebcDetailsLbl.text 		 	 = "\(detailsViewModel.beerDetailsEBC ?? 0)"
			self.ibuDetailsLbl.text 		 	 = "\(detailsViewModel.beerDetailsIBU ?? 0)"
			self.phDetailsLbl.text  		 	 = "\(detailsViewModel.beerDetailsPH ?? 0)"
			self.contributionDetailsLbl.text 	 = "\(String(describing: detailsViewModel.beerDetailsContributedBy))"
		}
	}
}
