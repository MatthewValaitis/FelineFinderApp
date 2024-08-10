//
//  CatViewModel.swift
//  FelineFinderApp
//
//  Created by Matthew Valaitis on 10/08/2024.
//

import Foundation

class CatViewModel: ObservableObject {
    
    let apiClient: CatApiClient
    
    var catImages: [CatModel] = []
    
    init(apiClient: CatApiClient) {
        self.apiClient = apiClient
    }
    
    func setCatImages() async {
        do {
            catImages = try await apiClient.fetchCatImages()
        } catch {
            print("Error: \(error)")
        }
    }
}
