//
//  ImageLoader.swift
//  FelineFinderApp
//
//  Created by Matthew Valaitis on 10/08/2024.
//

import Foundation
import SwiftUI

//TODO: Maybe make a protocol
final class ImageLoader: ObservableObject {
    
    let cacheManager: CacheManager
    
    init(cacheManager: CacheManager) {
        self.cacheManager = cacheManager
    }
    
    func getImage(for url: URL) async -> UIImage? {
        if let returnedImage = cacheManager.getImage(forKey: url.absoluteString) {
            print("Getting Image from Cache")
            return returnedImage
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let returnedImage = UIImage(data: data) {
                cacheManager.saveImage(returnedImage, forKey: url.absoluteString)
                print("Downloading Image")
                return returnedImage
            } else {
                return nil
            }
        } catch {
            print("Error loading image: \(error.localizedDescription)")
            return nil
        }
    }
}
