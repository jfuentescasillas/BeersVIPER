//
//  FavoriteBeersTableViewCell.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 06/04/22.
//

import UIKit

class FavoriteBeersTableViewCell: UITableViewCell {
	@IBOutlet weak var favBeerImageView: UIImageView!
	@IBOutlet weak var favBeerNameLbl: UILabel!
	@IBOutlet weak var favBeerDescriptionLbl: UILabel!
	
    
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	
	// MARK: - Configuration
	func configure(with viewModel: FavoriteBeer) {
		favBeerNameLbl.text = viewModel.favBeerName
		favBeerDescriptionLbl.text = viewModel.favBeerDescription
		
		guard let favBeerImg = viewModel.favBeerImage else { return }
		favBeerImageView.image = UIImage(data: favBeerImg)
	}
}
