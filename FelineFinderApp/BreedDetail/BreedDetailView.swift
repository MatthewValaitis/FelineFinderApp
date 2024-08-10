//
//  BreedDetailsView.swift
//  FelineFinderApp
//
//  Created by Matthew Valaitis on 10/08/2024.
//

import SwiftUI

struct BreedDetailsView: View {
    
    @State var viewModel: BreedDetailViewModel
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
                    .fill(ColorPalette.blush)
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea()
                    .padding()
            )
            .background(
                ColorPalette.offWhite
                    .ignoresSafeArea())
            .onAppear {
                Task {
                    await viewModel.setCatImages(for: breedDetails)
                }
        }
    }
    
    var detailsTextView: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("\(breedDetails.name).")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.white)
                    .padding(.leading)

                divider

                descriptionText

                Spacer()

            }
            .padding()
            .frame(maxHeight: .infinity)

            ratingView
                .padding(.bottom, 50)
                .offset(x: 30)
        }
    }
    
    var divider: some View {
        Rectangle()
            .frame(height: 1)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 10)
            .foregroundColor(ColorPalette.beige)
    }
    
    var descriptionText: some View {
        ScrollView {
            Text(breedDetails.description)
                .padding(.horizontal)
        }
    }
    
    var ratingView: some View {
        HStack {
            VStack(alignment: .trailing) {
                Text("Affection:")
                Text("Energy:")
                Text("Dog Friendly:")
            }
            .ignoresSafeArea()
            .fontWeight(.heavy)
            .frame(maxWidth: .infinity)
            .padding(.top, 30)

            VStack(alignment: .leading) {
                Text(String(repeating: "♥️", count: breedDetails.affectionLevel))
                Text(String(repeating: "⚡️", count: breedDetails.energyLevel))
                Text(String(repeating: "🐶", count: breedDetails.dogFriendlyLevel))
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 30)
        }
        .padding(.bottom, 40)
        .background(
            RoundedRectangle(cornerRadius: 12).fill(ColorPalette.sunset)
        )
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
                .padding(.leading)
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
                        .offset(y: phase.isIdentity ? 0 : 40)
                        .offset(x: phase.isIdentity ? 0 : -40)
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
    BreedDetailsView(
        viewModel: BreedDetailViewModel(
            apiClient: MockAPIClient(
                catImages: [
                    CatModel(
                        id: "beng",
                        width: 1000,
                        height: 1000,
                        url: URL(string: "https://cdn2.thecatapi.com/images/ave.jpg")!,
                        breeds: []
                    ),
                    CatModel(
                        id: "beng2",
                        width: 1000,
                        height: 1000,
                        url: URL(string: "https://cdn2.thecatapi.com/images/ave.jpg")!,
                        breeds: []
                    )
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
            wikipediaURL: "",
            affectionLevel: 3,
            energyLevel: 2,
            dogFriendlyLevel: 4
        )
    )
    .environmentObject(ImageLoader(cacheManager: CacheManager()))
}
