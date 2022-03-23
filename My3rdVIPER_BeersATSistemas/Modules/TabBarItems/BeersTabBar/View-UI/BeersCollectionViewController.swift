//
//  BeersCollectionViewController.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 14/03/22.
//


import UIKit


class BeersCollectionViewController: UIViewController, BeersCollectionViewContract {
	// MARK: Properties
	var presenter: BeerCollectionPresenterContract?
	private let numberOfColumns: CGFloat = 1
	private var cellLayout: UICollectionViewFlowLayout {
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
	@IBOutlet weak var beersCollectionView: UICollectionView!
	
		
	// MARK: - Life cycle
	override func viewDidLoad() {
        super.viewDidLoad()

		presenter?.viewDidLoad()
    }
	
	
	// MARK: - Contract/Protocol methods
	func reloadData() {
		DispatchQueue.main.async {
			self.beersCollectionView.reloadData()
		}
	}
	
	
	// MARK: - LayoutSubviews
	// Writes the layout subviews programmed after didLoad
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		beersCollectionView.setCollectionViewLayout(cellLayout, animated: false)
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
}
