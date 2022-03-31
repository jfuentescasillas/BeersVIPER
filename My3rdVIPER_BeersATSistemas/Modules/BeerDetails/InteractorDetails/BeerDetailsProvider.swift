//
//  BeerDetailsProvider.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 30/03/22.
//
// Example of Beer Details using url with beerID: https://api.punkapi.com/v2/beers/13


import Foundation


class NetworkBeerDetailsProvider: BeerDetailsProviderContract {
	func getBeerDetails(beerID: Int, _ completion: @escaping (Result<[BeerModel], BeersCollectionProviderError>) -> ()) {
		let beerURLWithID = "https://api.punkapi.com/v2/beers/\(beerID)"
		//print("beerURLWithID: \(beerURLWithID)")
		
		guard let url = URL(string: beerURLWithID) else {
			completion(.failure(.badUrl))
			
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
					let beerDecoder = try JSONDecoder().decode([BeerModel].self, from: beerData)
					completion(.success(beerDecoder))
				} catch let errorDecodingBeer {
					completion(.failure(.generic(errorDecodingBeer)))
					//fatalError("File could not be parsed: \(String(describing: beerError?.localizedDescription))")
				}
			} else {
				fatalError("Error in statuscode: \(beerResponse.statusCode)")
			}
		}
		
		task.resume()
	}
}
