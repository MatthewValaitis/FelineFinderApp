//
//  APIClientTests.swift
//  FelineFinderApp
//
//  Created by Matthew Valaitis on 10/08/2024.
//

import Foundation
import XCTest
@testable import FelineFinderApp

final class CatAPIClientTests: XCTestCase {
    
    func test_Given_BreedsPath_When_MakeUrl_Then_ReturnCorrectAbsolutePath() throws {
        // Given
        let baseURL = "www.example.com"
        let apiKey = "key"
        let limit = 1
        let sut = CatAPIClient(baseURL: baseURL, apiKey: apiKey)
        let expectedURL = URL(string: "www.example.com/breeds?limit=\(limit)&api_key=\(apiKey)")
        
        // When
        let actualURL = try sut.makeURL(path: .breeds, limit: limit)
        
        // Then
        XCTAssertEqual(actualURL, expectedURL)
    }
}
