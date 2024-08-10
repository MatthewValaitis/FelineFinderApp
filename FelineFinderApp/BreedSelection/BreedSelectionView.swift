//
//  BreedSelectionView.swift
//  FelineFinderApp
//
//  Created by Matthew Valaitis on 10/08/2024.
//

import SwiftUI

struct BreedSelectionView: View {
    
    @State var viewModel: BreedSelectionViewModel
    
    let columns = [
        GridItem(.flexible(), spacing: 16)]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.breeds, id: \.self) { breed in
                    Text(breed.name)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.setBreeds()
            }
        }
    }
}

#Preview {
    BreedSelectionView(viewModel: BreedSelectionViewModel(apiClient: CatApiClient()))
}
