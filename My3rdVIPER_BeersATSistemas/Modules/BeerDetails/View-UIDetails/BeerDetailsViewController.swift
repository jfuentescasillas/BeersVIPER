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
	var detailsViewModel: BeerDetailsViewModel?
	
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
	func configure() {
		guard let detailsViewModel = detailsViewModel else { return }

		beerNameDetailsLbl.text = detailsViewModel.beerDetailsName
		beerDescriptionDetailsLbl.text = detailsViewModel.beerDetailsDescription
		beerTaglineDetailsLbl.text = detailsViewModel.beerDetailsTagline
	}
}
