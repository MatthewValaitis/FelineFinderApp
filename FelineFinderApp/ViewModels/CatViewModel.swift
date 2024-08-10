//
//  CatViewModel.swift
//  FelineFinderApp
//
//  Created by Matthew Valaitis on 10/08/2024.
//

import Foundation

@Observable
class CatViewModel: ObservableObject {
    
    enum ViewState {
        case loading
        case loaded
        case error
    }
    
    private(set) var state: ViewState = .loading
    
    let apiClient: APIClient
    
    var catImages: [CatModel] = []
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    @MainActor
    //TODO: View state is loading, fetched, error (ContentUnavailble)
    func setCatImages(for breed: BreedDetails) async {
        do {
            state = .loading
            catImages = try await apiClient.fetchCatImages(breedID: breed.id)
            state = .loaded
        } catch {
            print("Error: \(error)")
            state = .error
        }
    }
}
