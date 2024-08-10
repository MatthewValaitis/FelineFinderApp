//
//  FelineFinderAppTests.swift
//  FelineFinderAppTests
//
//  Created by Matthew Valaitis on 10/08/2024.
//

import Foundation
import XCTest
@testable import FelineFinderApp

final class FelineFinderAppTests: XCTestCase {

    func test_Given_BreedDetails_When_SetBreedsIsCalled_Then_StateIsLoaded() async {
        // Given
        let sut = BreedSelectionViewModel(apiClient: MockAPIClient())
        
        // When
        await sut.setBreeds()
        
        // Then
        XCTAssertEqual(sut.state, .loaded)
    }
    
    func test_Given_NoInternet_When_SetBreedsIsCalled_Then_StateIsError() async {
        // Given
        let mockAPIClient = MockAPIClient(alwaysError: true)
        let sut = BreedSelectionViewModel(apiClient: mockAPIClient)
        
        // When
        await sut.setBreeds()
        
        // Then
        XCTAssertEqual(sut.state, .error)
    }
    
    func test_Given_BreedDetails_When_SetBreedsIsCalled_Then_BreedsIsSet() async {
        // Given
        let breedDetails = [BreedDetails.stub()]
        let mockAPIClient = MockAPIClient(breedDetails: breedDetails)
        let sut = BreedSelectionViewModel(apiClient: mockAPIClient)
        
        // When
        await sut.setBreeds()
        
        // Then
        XCTAssertEqual(sut.breeds, breedDetails)
    }
    
    func test_Given_SearchText_When_FilteredBreeds_Then_ReturnsCorrectBreeds() async throws {
        // Given
        let searchText = "curl"
        let breedDetails = [
            BreedDetails.stub(name: "American Curl"),
            BreedDetails.stub(name: "American Shorthair")]
        
        let mockAPIClient = MockAPIClient(breedDetails: breedDetails)
        let sut = BreedSelectionViewModel(apiClient: mockAPIClient)
        
        await sut.setBreeds()
        
        // When
        sut.searchText = searchText
        let filteredDetails = sut.filteredBreeds()
        
        // Then
        XCTAssertEqual(filteredDetails.count, 1)
        let filteredDetail = try XCTUnwrap(filteredDetails.first)
        XCTAssertEqual(filteredDetail.name, "American Curl")
        
    }
}

// MARK: Breed Details Stub

extension BreedDetails {
    
    static func stub(
        id: String = UUID().uuidString,
        name: String = "Bengal",
        description: String = "A Cat",
        origin: String = "Portugal",
        temperament: String = "Nice",
        lifeSpan: String = "0 - 100",
        wikipediaURL: String = "URL"
    ) -> BreedDetails {
        BreedDetails(
            id: id,
            name: name,
            description: description,
            origin: origin,
            temperament: temperament,
            lifeSpan: lifeSpan,
            wikipediaURL: wikipediaURL)
    }
}
