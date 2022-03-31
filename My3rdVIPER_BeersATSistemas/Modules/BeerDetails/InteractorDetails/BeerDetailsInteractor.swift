//
//  BeerDetailsInteractor.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 18/03/22.
//


import Foundation


class BeerDetailsInteractor: BeerDetailsInteractorContract {
	var output: BeerDetailsInteractorOutputContract?
	var beer: [BeerModel]?
	var beerDetailsProvider: BeerDetailsProviderContract?
	
		
	func fetchBeer(withID: Int) {
		beerDetailsProvider?.getBeerDetails(beerID: withID, { beerDetailsResult in
			switch beerDetailsResult {
			case .success(let beerDetails):
				self.output?.didFetch(beer: beerDetails)
				
			case .failure:
				self.output?.fetchDidFail(error: "Error Fetching the beer details")
			}
		})
		// OLD CODE
		/*let beerURLWithID = "https://api.punkapi.com/v2/beers/\(withID)"
		//print("beerURLWithID: \(beerURLWithID)")
		
		guard let url = URL(string: beerURLWithID) else {
			output?.fetchDidFail(error: "Error with BeerID request")
			
			return
		}
		
		let request = URLRequest(url: url)
		let task = URLSession.shared.dataTask(with: request) { (beerData, beerResponse, beerError) in
			guard let beerData = beerData, beerError == nil, let beerResponse = beerResponse as? HTTPURLResponse else {
				fatalError("Error in connection: \(String(describing: beerError))")
			}

			// Conection is valid
			if beerResponse.statusCode == 200 {
				//print("This is the Beer Data: \(beerData)")
				
				do {
					let decoder = JSONDecoder()
					self.beer = try decoder.decode([BeerModel].self, from: beerData)
					
					// Send back the data to Interactor, so that the Interactor sends it back to the Presenter
					self.output?.didFetch(beer: self.beer!)
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
	
	
	// MARK: - Deinit
	deinit {
		print("Deinit \(self)")
	}
}
