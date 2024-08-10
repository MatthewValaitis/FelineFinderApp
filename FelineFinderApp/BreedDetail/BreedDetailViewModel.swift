//
//  BreedDetailViewModel.swift
//  FelineFinderApp
//
//  Created by Matthew Valaitis on 10/08/2024.
//

import Foundation
import SwiftUI

@Observable
class BreedDetailViewModel: ObservableObject {
    
    enum ViewState {
        case loading
        case loaded
        case error
    }
    
    private(set) var state: ViewState = .loading
    
    let apiClient: APIClient
    
    var catImages: [CatImage] = []
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    @MainActor
    func setCatImages(for breed: BreedDetails) async {
        guard state != .loaded else { return }
        do {
            state = .loading
            catImages = try await apiClient.fetchCatImages(breedID: breed.id)
            withAnimation {
                state = .loaded
            }
        } catch {
            print("Error: \(error)")
            state = .error
        }
    }
}
