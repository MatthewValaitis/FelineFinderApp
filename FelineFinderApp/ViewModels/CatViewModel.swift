//
//  CatViewModel.swift
//  FelineFinderApp
//
//  Created by Matthew Valaitis on 10/08/2024.
//

import Foundation

@Observable
class CatViewModel: ObservableObject {
    
    let apiClient: CatApiClient
    
    var catImages: [CatModel] = []
    
    init(apiClient: CatApiClient) {
        self.apiClient = apiClient
    }
    
    @MainActor
    //TODO: View state is loading, fetched, error (ContentUnavailble)
    func setCatImages(for breed: BreedDetails) async {
        do {
            catImages = try await apiClient.fetchCatImages(breedID: breed.id)
        } catch {
            print("Error: \(error)")
        }
    }
}
