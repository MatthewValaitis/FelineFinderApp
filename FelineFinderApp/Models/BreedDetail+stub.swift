//
//  BreedDetail+stub.swift
//  FelineFinderApp
//
//  Created by Matthew Valaitis on 10/08/2024.
//

import Foundation

// MARK: Breed Details Stub

extension BreedDetails {
    
    static func stub(
        id: String = UUID().uuidString,
        name: String = "Bengal",
        description: String = "A Cat",
        origin: String = "Portugal",
        temperament: String = "Nice",
        lifeSpan: String = "0 - 100",
        wikipediaURL: String = "URL",
        affectionLevel: Int = 0,
        energyLevel: Int = 0,
        dogFriendlyLevel: Int = 0
    ) -> BreedDetails {
        BreedDetails(
            id: id,
            name: name,
            description: description,
            origin: origin,
            temperament: temperament,
            lifeSpan: lifeSpan,
            wikipediaURL: wikipediaURL,
            affectionLevel: affectionLevel,
            energyLevel: energyLevel,
            dogFriendlyLevel: dogFriendlyLevel
        )
    }
}
