//
//  BreedSelectionView.swift
//  FelineFinderApp
//
//  Created by Matthew Valaitis on 10/08/2024.
//

import SwiftUI

struct BreedSelectionView: View {
    
    @State var viewModel: BreedSelectionViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .loading:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .loaded:
                    breedList
                case .error:
                    ContentUnavailableView("Error Fetching Breeds", systemImage: "xmark")
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Cat Breeds")
            .navigationDestination(for: BreedDetails.self) { breed in
                CatGalleryView(viewModel: CatViewModel(apiClient: viewModel.apiClient), breedDetails: breed)
            }
            .onAppear {
                Task {
                    await viewModel.setBreeds()
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search Breeds")
        }
    }
    
    var breedList: some View {
            List {
                ForEach(viewModel.filteredBreeds(), id: \.self) { breed in
                    NavigationLink(value: breed) {
                        Text(breed.name)
                    }
                }
            }
    }
}

#Preview {
    BreedSelectionView(viewModel: BreedSelectionViewModel(apiClient: CatAPIClient()))
}
