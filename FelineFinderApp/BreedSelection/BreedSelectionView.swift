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
                BreedDetailsView(viewModel: BreedDetailViewModel(apiClient: viewModel.apiClient), breedDetails: breed)
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
                    VStack(alignment: .leading) {
                        Text(breed.name)
                            .fontWeight(.heavy)
                            .bold()

                        Text("\(breed.origin)")
                            .font(.subheadline)
                            .padding(.vertical, 3)
                    }
                    .padding(.vertical, 5)
                }
                .foregroundColor(.white)
                .listRowBackground(ColorPalette.blush)
                .listRowSeparatorTint(.white)
            }
        }
    }
}

#Preview {
    BreedSelectionView(
        viewModel: BreedSelectionViewModel(
            apiClient: MockAPIClient(
                breedDetails: [
                    BreedDetails.stub(),
                    BreedDetails.stub(),
                    BreedDetails.stub(),
                ],
                catImages: [
                    CatModel(
                        id: "beng",
                        width: 1000,
                        height: 1000,
                        url: URL(string: "https://cdn2.thecatapi.com/images/ave.jpg")!,
                        breeds: []
                    )
                ]
            )
        )
    )
    .environmentObject(ImageLoader(cacheManager: CacheManager()))
    .tint(ColorPalette.blush)
}
