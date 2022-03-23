//
//  BeersModel.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 16/03/22.
//


import Foundation


struct BeerModel: Codable {
	let id: Int
	let name, tagline, firstBrewed, beerDescription: String
	let imageURL: String
	let abv: Double
	let ibu: Double?
	let targetFg: Int
	let targetOg: Double
	let ebc, srm, ph: Double?
	let attenuationLevel: Double
	/*let volume, boilVolume: BoilVolume
	let method: Method
	let ingredients: Ingredients*/
	let foodPairing: [String]
	let brewersTips: String
	let contributedBy: ContributedBy
	
	enum CodingKeys: String, CodingKey {
		case id, name, tagline
		case firstBrewed 	  = "first_brewed"
		case beerDescription  = "description"
		case imageURL 		  = "image_url"
		case abv, ibu
		case targetFg 		  = "target_fg"
		case targetOg 		  = "target_og"
		case ebc, srm, ph
		case attenuationLevel = "attenuation_level"
		/*case volume
		case boilVolume = "boil_volume"
		case method, ingredients */
		case foodPairing   	  = "food_pairing"
		case brewersTips   	  = "brewers_tips"
		case contributedBy 	  = "contributed_by"
	}
}


enum ContributedBy: String, Codable {
	case aliSkinnerAliSkinner = "Ali Skinner <AliSkinner>"
	case mattBallGeordieMatt  = "Matt Ball <GeordieMatt>"
	case samMasonSamjbmason   = "Sam Mason <samjbmason>"
}


// MARK: - Extension: BeerModel
extension BeerModel {
	var toCollectionCellViewModel: BeerCollectionViewCellViewModel {
		return BeerCollectionViewCellViewModel(beerImageURL: URL(string: imageURL), beerName: name, beerDescription: beerDescription)
	}
	var toDetailsViewModel: BeerDetailsViewModel {
		return BeerDetailsViewModel(beerDetailsID: id, beerDetailsName: name,
									beerDetailsDescription: beerDescription, beerDetails1stBrewed: firstBrewed,
									beerDetailsTagline: tagline, beerDetailsimageURL: URL(string: imageURL),
									beerDetailsAbv: abv, beerDetailsPH: ph, beerDetailsFoodPairing: foodPairing,
									beerDetailsBrewersTips: brewersTips, beerDetailsContributedBy: contributedBy)
	}
}
