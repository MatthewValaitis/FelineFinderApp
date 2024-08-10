//
//  MockAPIClient.swift
//  FelineFinderApp
//
//  Created by Matthew Valaitis on 10/08/2024.
//

import Foundation

struct MockAPIClient: APIClient {
    
    let breedDetails: [BreedDetails]
    let catImages: [CatImage]
    let alwaysError: Bool
    
    init(
        breedDetails: [BreedDetails] = [],
        catImages: [CatImage] = [],
        alwaysError: Bool = false
    ) {
        self.breedDetails = breedDetails
        self.catImages = catImages
        self.alwaysError = alwaysError
    }
    
    func fetchBreedData() async throws -> [BreedDetails] {
        if alwaysError {
            throw URLError(.notConnectedToInternet)
        }
        return breedDetails
    }
    
    func fetchCatImages(breedID: String) async throws -> [CatImage] {
        if alwaysError {
            throw URLError(.notConnectedToInternet)
        }
        return catImages
    }
}
