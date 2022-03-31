//
//  BeersCollectionProvider.swift
//  My3rdVIPER_BeersATSistemas
//
//  Created by Jorge Fuentes Casillas on 30/03/22.
//
// Example of Standard url request with pagination: https://api.punkapi.com/v2/beers?page=1&per_page=80
// Example of Search beer request with pagination: https://api.punkapi.com/v2/beers?beer_name=e?&page=3&per_page=80


import Foundation


enum BeersCollectionProviderError: Error {
	case badUrl
	case generic(Error?)
}


class NetworkBeersCollectionProvider: BeersCollectionProviderContract {
	func getBeersCollection(pageNumber: Int, _ completion: @escaping (Result<[BeerModel], BeersCollectionProviderError>) -> ()) {
		let beerUrl: String = "https://api.punkapi.com/v2/beers?page=\(pageNumber)&per_page=80"
		
		guard let url = URL(string: beerUrl) else {
			completion(.failure(.badUrl))
			
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
				do {
					let beersDecoder = try JSONDecoder().decode([BeerModel].self, from: beerData)
					completion(.success(beersDecoder))
				} catch let errorDecodingBeers {
					completion(.failure(.generic(errorDecodingBeers)))
					//fatalError("File could not be parsed: \(String(describing: beerError?.localizedDescription))")
				}
			} else {
				fatalError("Error in statuscode (getting Beers): \(beerResponse.statusCode)")
			}
		}
		
		task.resume()
	}
	
	
	func searchBeersCollection(beerName: String, pageNumber: Int, _ completion: @escaping (Result<[BeerModel], BeersCollectionProviderError>) -> ()) {
		let beerUrl: String = "https://api.punkapi.com/v2/beers?beer_name=\(beerName)?&page=\(pageNumber)&per_page=80"
		
		guard let url = URL(string: beerUrl) else {
			completion(.failure(.badUrl))
			
			return
		}
		
		print("URL search: \(url)")
		
		let request = URLRequest(url: url)
		let task = URLSession.shared.dataTask(with: request) { (searchedBeerData, searchedBeerResponse, searchedBeerError) in
			guard let searchedBeerData = searchedBeerData, searchedBeerError == nil, let searchedBeerResponse = searchedBeerResponse as? HTTPURLResponse else {
				fatalError("Error in connection: \(String(describing: searchedBeerError))")
			}

			// Conection is valid
			if searchedBeerResponse.statusCode == 200 {
				do {
					let searchedBeersDecoder = try JSONDecoder().decode([BeerModel].self, from: searchedBeerData)
					completion(.success(searchedBeersDecoder))
				} catch let errorDecodingsearchedBeers {
					completion(.failure(.generic(errorDecodingsearchedBeers)))
					//fatalError("File could not be parsed: \(String(describing: beerError?.localizedDescription))")
				}
			} else {
				fatalError("Error in statuscode (searching Beers): \(searchedBeerResponse.statusCode)")
			}
		}
		
		task.resume()
	}
	
	
	// MARK: - Deinit
	deinit {
		print("Deinit \(self)")
	}
}
