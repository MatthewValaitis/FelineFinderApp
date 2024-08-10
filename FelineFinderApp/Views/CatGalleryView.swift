//
//  CatGalleryView.swift
//  FelineFinderApp
//
//  Created by Matthew Valaitis on 10/08/2024.
//

import SwiftUI

struct CatGalleryView: View {
    
    @State var viewModel: CatViewModel
    
    let breedDetails: BreedDetails
    
    var body: some View {
        VStack {
            Text(breedDetails.name)
                .font(.headline)
            Text(breedDetails.description)
                .font(.caption)
                .multilineTextAlignment(.leading)
            ScrollView(.horizontal) {
                LazyHStack(spacing: 16) {
                    ForEach(viewModel.catImages) { catImage in
                        HStack {
                            AsyncImage(url: catImage.url)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                                .cornerRadius(8.0)
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.setCatImages(for: breedDetails)
                }
            }
        }
    }
}

#Preview {
    CatGalleryView(viewModel: CatViewModel(apiClient: CatAPIClient()),
                   breedDetails: BreedDetails(
                    id: "beng",
                    name: "Bengal",
                    description: "A cat",
                    origin: "Portugal",
                    temperament: "Lovely",
                    lifeSpan: "0-100",
                    wikipediaURL: ""))
}
