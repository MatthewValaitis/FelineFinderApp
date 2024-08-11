//
//  CatAPIClient.swift
//  FelineFinderApp
//
//  Created by Matthew Valaitis on 10/08/2024.
//

import Foundation
import SwiftUI

struct CatAPIClient: APIClient {
    
    enum APIClientError: Error {
        case failedToCreateURL
    }
    
    enum Path: String {
        case images = "images/search"
        case breeds
    }
    
    let baseURL: String
    let apiKey: String
    
    init(baseURL: String = "https://api.thecatapi.com/v1",
         apiKey: String = "live_KhlFAA2evvNGOAN963yWgZWCNJTYIxpAZbb88GeqTFcrUSYn23yNMlUYLDxws73S"
    ) {
        self.baseURL = baseURL
        self.apiKey = apiKey
    }
    
    
    func makeURL(path: Path, limit: Int = 100) throws -> URL {
        guard var url = URL(string: baseURL) else {
            throw APIClientError.failedToCreateURL
        }
        url.append(path: path.rawValue)
        
        let queryItems = [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "api_key", value: apiKey),
        ]
        
        url.append(queryItems: queryItems)
        
        return url
    }
    
    func fetchCatImages(breedID: String) async throws -> [CatImage] {
        var url = try makeURL(path: Path.images)
        
        url.append(queryItems: [
            URLQueryItem(name: "breed_ids", value: breedID)
        ])
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let catImages = try JSONDecoder().decode([CatImage].self, from: data)
        return catImages
    }
    
    func fetchBreedData() async throws -> [BreedDetails] {
        let url = try makeURL(path: Path.breeds)
        let (data, _) = try await URLSession.shared.data(from: url)
        let breedDetails = try JSONDecoder().decode([BreedDetails].self, from: data)

        return breedDetails
    }
}
