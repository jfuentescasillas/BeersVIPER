//
//  BeerCollectionViewCell.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 15/03/22.
//

import UIKit


struct BeerCollectionViewCellViewModel {
	let beerImageURL: URL?
	let beerName: String?
	let beerDescription: String?
}


class BeerCollectionViewCell: UICollectionViewCell {
	// MARK: Elements in ViewCell
	@IBOutlet weak var beerImage: UIImageView!
	@IBOutlet weak var beerNameLbl: UILabel!
	@IBOutlet weak var beerDescriptionLbl: UILabel!
	
		
	func configure(with viewModel: BeerCollectionViewCellViewModel) {
		guard let beerImgURL = viewModel.beerImageURL else {
			beerImage.image = UIImage(named: "beerPlaceholder-60x60")
			
			return
		}
		
		beerImage.downloaded(from: beerImgURL)
		beerNameLbl.text = viewModel.beerName
		beerDescriptionLbl.text = viewModel.beerDescription
		
		contentView.layer.cornerRadius = 10
		contentView.layer.masksToBounds = true
		
		layer.shadowColor = UIColor.gray.cgColor
		layer.shadowOffset = CGSize(width: 0, height: 2)
		layer.shadowRadius = 2
		layer.shadowOpacity = 1
		layer.masksToBounds = false
		layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
	}	
}
