//
//  FelineFinderAppApp.swift
//  FelineFinderApp
//
//  Created by Matthew Valaitis on 10/08/2024.
//

import SwiftUI

@main
struct FelineFinderAppApp: App {
    var body: some Scene {
        WindowGroup {
            BreedSelectionView(viewModel: BreedSelectionViewModel(apiClient: CatAPIClient()))
        }
    }
}
