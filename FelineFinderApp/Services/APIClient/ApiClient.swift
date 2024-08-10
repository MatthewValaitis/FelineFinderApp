//
//  APIClient.swift
//  FelineFinderApp
//
//  Created by Matthew Valaitis on 10/08/2024.
//

import Foundation

protocol APIClient {
    
    func fetchBreedData() async throws -> [BreedDetails]
    func fetchCatImages(breedID: String) async throws -> [CatImage]
}
