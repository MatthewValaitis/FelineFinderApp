//
//  BreedSelectionViewModel.swift
//  FelineFinderApp
//
//  Created by Matthew Valaitis on 10/08/2024.
//

import Foundation

@Observable
final class BreedSelectionViewModel {
    
    let apiClient: CatApiClient
    
    private(set) var breeds: [BreedDetails] = []
    
    init(apiClient: CatApiClient) {
        self.apiClient = apiClient
    }
    
    @MainActor
    func setBreeds() async {
        do {
            breeds = try await apiClient.fetchBreedData()
        } catch {
            print("Could not fetch breeds")
        }
    }
}
