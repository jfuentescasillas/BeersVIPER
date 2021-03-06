//
//  BeersCollectionInteractor.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 17/03/22.
//


import Foundation


class BeersCollectionInteractor: BeerCollectionInteractorContract {
	// MARK: - Properties
	var output: BeerCollectionInteractorOutputContract?
	var beersProvider: BeersCollectionProviderContract?
	
	var beers = [BeerModel]()
	
	
	func fetchBeers(pageNumber: Int) {
		beersProvider?.getBeersCollection(pageNumber: pageNumber, { beersResult in
			switch beersResult {
			case .success(let beers):
				self.output?.didFetch(beers: beers)
				
			case .failure:
				self.output?.fetchDidFail(error: "Error Fetching the beers")
			}
		})
		// OLD CODE
		/*let beerUrl: String = "https://api.punkapi.com/v2/beers?page=\(pageNumber)&per_page=80"
		guard let url = URL(string: beerUrl) else {
			output?.fetchDidFail(error: "Error in Beer URL")
			
			return
		}
		
		//print("FetchBeers in CollectionInteractor. URL: \(url)")
		let request = URLRequest(url: url)
		let task = URLSession.shared.dataTask(with: request) { (beerData, beerResponse, beerError) in
			guard let beerData = beerData, beerError == nil, let beerResponse = beerResponse as? HTTPURLResponse else {
				fatalError("Error in connection: \(String(describing: beerError))")
			}

			// Conection is valid
			if beerResponse.statusCode == 200 {
				/*print("This is the Beer Data (Inside CollectionInteractor): \(beerData)")
				print("self.beers BEFORE JSONDecoder(): \(self.beers)")*/
				
				do {
					let decoder = JSONDecoder()
					self.beers = try decoder.decode([BeerModel].self, from: beerData)
					//print("self.beers AFTER JSONDecoder(): \(self.beers)")
					
					// Send back the data to Interactor, so that the Interactor sends it back to the Presenter
					self.output?.didFetch(beers: self.beers)
				} catch {
					self.output?.fetchDidFail(error: "\(String(describing: beerError))")
					//fatalError("File could not be parsed: \(String(describing: beerError?.localizedDescription))")
				}
			} else {
				fatalError("Error in statuscode: \(beerResponse.statusCode)")
			}
		}
		
		task.resume()*/
	}
	
	
	func searchBeers(beerName: String, pageNumber: Int) {
		beersProvider?.searchBeersCollection(beerName: beerName, pageNumber: pageNumber, { searchResults in
			switch searchResults {
			case .success(let searchedBeers):
				self.output?.didFetch(beers: searchedBeers)
				
			case .failure:
				self.output?.fetchDidFail(error: "Error Fetching the searched beers")
			}
		})
	}
	
	
	// MARK: - Deinit
	deinit {
		print("Deinit \(self)")
	}
}
