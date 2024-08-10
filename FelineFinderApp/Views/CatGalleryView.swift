//
//  CatGalleryView.swift
//  FelineFinderApp
//
//  Created by Matthew Valaitis on 10/08/2024.
//

import SwiftUI

struct CatGalleryView: View {
    
    @StateObject private var imageLoader = ImageLoader(cacheManager: CacheManager())
    
    @State var viewModel: CatViewModel
    @State var selectedImage: CatModel?
    
    let breedDetails: BreedDetails
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .loaded:
                breedDetailsView
            case .error:
                ContentUnavailableView("Cat Gallery Failed To Load", systemImage: "xmark")
            }
        }
        .onAppear {
            Task {
                await viewModel.setCatImages(for: breedDetails)
            }
        }
    }
    
    var detailsTextView: some View {
        VStack(spacing: 10) {
            Text(breedDetails.name)
                .font(.title)
            Divider()
            Text(breedDetails.description)
                .font(.body)
                .multilineTextAlignment(.leading)
            VStack(alignment: .leading, spacing: 10) {
                Text("Life span: \(breedDetails.lifeSpan)")
                Text("Place of origin: \(breedDetails.origin)")
                Text("Temperament: \(breedDetails.temperament)")
            }
            .padding(10)
            .font(.caption)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(30)
    }
    
    var imageGalleryView: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 16) {
                ForEach(viewModel.catImages) { catImage in
                    HStack {
                        NavigationLink(value: breedDetails) {
                            CachedAsyncImage(url: catImage.url)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 300, height: 300)
                                .cornerRadius(8.0)
                                .environmentObject(imageLoader)
                        }
                        .padding(.leading, 10)
                        .scrollTransition{ content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0)
                                .offset(y: phase.isIdentity ? 0 : 60)
                                .scaleEffect(phase.isIdentity ? 1 : 0.5)
                        }
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedImage = catImage
                            }
                        }
                    }
                }
            }
        }
        .ignoresSafeArea()
        .scrollTargetLayout()
        .scrollTargetBehavior(.viewAligned)
        .scrollBounceBehavior(.basedOnSize)
        .sheet(item: $selectedImage) { cat in
            ExpandedImageView(url: cat.url)
        }
    }
    
    var breedDetailsView: some View {
        ZStack(alignment: .top) {
            VStack {
                detailsTextView
                imageGalleryView
            }
        }
    }
}

#Preview {
    CatGalleryView(viewModel: CatViewModel(apiClient: CatAPIClient()),
                   breedDetails: BreedDetails(
                    id: "beng",
                    name: "Bengal",
                    description: "A cat A cat A cat A cat A cat A cat A cat A cat A cat A cat A cat A cat A cat A cat A cat A cat A cat A cat A cat A cat A cat A cat",
                    origin: "Portugal",
                    temperament: "Alert, Agile, Energetic, Demanding, Intelligent",
                    lifeSpan: "0-100",
                    wikipediaURL: ""))
}
