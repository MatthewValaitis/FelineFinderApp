//
//  BreedSelectionViewModel.swift
//  FelineFinderApp
//
//  Created by Matthew Valaitis on 10/08/2024.
//

import Foundation

@Observable
final class BreedSelectionViewModel {
    
    enum ViewState {
        case loading
        case loaded
        case error
    }
    
    let apiClient: APIClient
    
    private(set) var state: ViewState = .loading
    private(set) var breeds: [BreedDetails] = []
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    @MainActor
    func setBreeds() async {
        guard state != .loaded else { return }
        do {
            state = .loading
            breeds = try await apiClient.fetchBreedData()
            state = .loaded
        } catch {
            print("Could not fetch breeds")
            state = .error
        }
    }
}
