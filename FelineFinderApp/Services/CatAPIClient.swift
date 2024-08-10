//
//  CatAPIClient.swift
//  FelineFinderApp
//
//  Created by Matthew Valaitis on 10/08/2024.
//

import Foundation
import SwiftUI

struct CatApiClient {
    
    enum APIClientError: Error {
        case failedToCreateURL
    }
    
    enum Path: String {
        case images = "images/search"
    }
    
    let baseURL: String = "https://api.thecatapi.com/v1"
    let apiKey: String = "live_KhlFAA2evvNGOAN963yWgZWCNJTYIxpAZbb88GeqTFcrUSYn23yNMlUYLDxws73S"
    
    
    func makeURL(path: Path, limit: Int = 20) throws -> URL {
        guard var url = URL(string: baseURL) else {
            throw APIClientError.failedToCreateURL
        }
        url.append(path: path.rawValue)
        
        var queryItems = [
            URLQueryItem(name: "limit", value: String(limit))
        ]
        
        url.append(queryItems: queryItems)
        
        return url
    }
    
    func fetchCatImages() async throws -> [CatModel] {
        var url = try makeURL(path: Path.images)
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let catImages = try JSONDecoder().decode([CatModel].self, from: data)
        return catImages
    }
}
