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
	let beerDetailsFoodPairing: [String]?
	let beerDetailsBrewersTips: String?
	let beerDetailsContributedBy: ContributedBy?
}


class BeerDetailsViewController: UIViewController, BeerDetailsViewContract {
	// MARK: - Properties related to the ViewContract
	var presenter: BeerDetailsPresenterContract?
	
	// MARK: - Elements in Storyboard
	@IBOutlet weak var beerNameDetailsLbl: UILabel!
	@IBOutlet weak var beerDescriptionDetailsLbl: UILabel!
	@IBOutlet weak var beerTaglineDetailsLbl: UILabel!
	
	
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
			self.beerNameDetailsLbl.text = detailsViewModel.beerDetailsName
			self.beerDescriptionDetailsLbl.text = detailsViewModel.beerDetailsDescription
			self.beerTaglineDetailsLbl.text = detailsViewModel.beerDetailsTagline
		}
	}
}
