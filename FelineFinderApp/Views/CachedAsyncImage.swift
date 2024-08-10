//
//  CachedAsyncImage.swift
//  FelineFinderApp
//
//  Created by Matthew Valaitis on 10/08/2024.
//

import Foundation
import SwiftUI

struct CachedAsyncImage: View {
    
    @EnvironmentObject var imageLoader: ImageLoader
    
    let url: URL
    
    @State private var image: UIImage?
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
            } else {
                ProgressView()
                    .onAppear {
                        Task {
                            self.image = await imageLoader.getImage(for: url)
                        }
                    }
            }
        }
    }
}
