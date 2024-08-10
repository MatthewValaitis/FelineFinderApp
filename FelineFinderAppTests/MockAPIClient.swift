//
//  MockAPIClient.swift
//  FelineFinderApp
//
//  Created by Matthew Valaitis on 10/08/2024.
//

import Foundation
@testable import FelineFinderApp

struct MockAPIClient: APIClient {
    
    let breedDetails: [BreedDetails]
    let catImages: [CatModel]
    let alwaysError: Bool
    
    init(
        breedDetails: [BreedDetails] = [],
        catImages: [CatModel] = [],
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
    
    func fetchCatImages(breedID: String) async throws -> [CatModel] {
        if alwaysError {
            throw URLError(.notConnectedToInternet)
        }
        return catImages
    }
}
