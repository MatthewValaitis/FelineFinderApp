//
//  CatGalleryView.swift
//  FelineFinderApp
//
//  Created by Matthew Valaitis on 10/08/2024.
//

import SwiftUI

enum ColorPalette {
    static let baige = Color(uiColor: UIColor(red: 1, green: 235/255, blue: 204/255, alpha: 1))
    static let sunset = Color(uiColor: UIColor(red: 242/255, green: 208/255, blue: 164/255, alpha: 1))
}

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
        .frame(maxHeight: .infinity, alignment: .top)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(ColorPalette.sunset)
                .frame(maxWidth: .infinity)
                .ignoresSafeArea()
                .padding()
        )
        .onAppear {
            Task {
                await viewModel.setCatImages(for: breedDetails)
            }
        }
    }
    
    var detailsTextView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(breedDetails.name)
                .font(.largeTitle.bold())
            
            divider
            
            descriptionText

            divider
            
            ratingView
        }
        .padding()
        .frame(maxHeight: .infinity)
    }
    
    var divider: some View {
        Rectangle()
            .frame(height: 1)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 4)
            .foregroundColor(.white)
    }
    
    var descriptionText: some View {
        ScrollView {
            Text(breedDetails.description)
        }
        .frame(height: 80)
    }
    
    var ratingView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Affection")
                Text("Energy")
                Text("Dog Friendliness")
            }
            .frame(maxWidth: .infinity)

            VStack(alignment: .leading) {
                Text(String(repeating: "♥️", count: breedDetails.affectionLevel))
                Text(String(repeating: "⚡️", count: breedDetails.energyLevel))
                Text(String(repeating: "🐶", count: breedDetails.dogFriendlyLevel))
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
    }
    
    var imageGalleryView: some View {
        VStack {
            ScrollView(.horizontal) {
                LazyHStack() {
                    ForEach(viewModel.catImages) { catImage in
                        catImageView(catImage)
                    }
                }
                .frame(height: 320)
            }
            .navigationDestination(for: CatModel.self, destination: { catImage in
                ExpandedImageView(url: catImage.url)
            })
            .scrollIndicators(.hidden)
            .scrollTargetLayout()
            .scrollTargetBehavior(.viewAligned)
            .scrollBounceBehavior(.basedOnSize)
        }
    }
    
    func catImageView(_ catImage: CatModel) -> some View {
        NavigationLink(value: catImage) {
            CachedAsyncImage(url: catImage.url)
                .aspectRatio(contentMode: .fill)
                .frame(width: 320, height: 320)
                .cornerRadius(8.0)
                .scrollTransition{ content, phase in
                    content
                        .opacity(phase.isIdentity ? 1 : 0.3)
                        .offset(y: phase.isIdentity ? 0 : 40)
                        .offset(x: phase.isIdentity ? 0 : -16)
                        .scaleEffect(phase.isIdentity ? 1 : 0.7)
                }
        }
    }
    
    var breedDetailsView: some View {
        VStack(spacing: 0) {
            imageGalleryView

            detailsTextView
        }
    }
}

#Preview {
    CatGalleryView(
        viewModel: CatViewModel(
            apiClient: MockAPIClient(
                catImages: [
                    CatModel(id: "beng", width: 1000, height: 1000, url: URL(string: "www.example.com")!, breeds: [])
                ]
            )
        ),
        breedDetails: BreedDetails.stub(
            id: "beng",
            name: "Bengal",
            description: "A cat A cat A cat A cat A cat A cat A cat A cat A cat A cat A cat A cat A cat A cat A cat A cat A cat A cat A cat A cat A cat A cat",
            origin: "Portugal",
            temperament: "Alert, Agile, Energetic, Demanding, Intelligent",
            lifeSpan: "0-100",
            wikipediaURL: ""
        )
    )
}
