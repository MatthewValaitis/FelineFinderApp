//
//  APIModels.swift
//  FelineFinderApp
//
//  Created by Matthew Valaitis on 10/08/2024.
//

import Foundation


// Struct used for getting Images via url

struct CatModel: Decodable {
    
    let id: String
    let width: Int
    let height: Int
    let url: URL
    let breeds: [BreedDetails]
}

// nested values needed for breeds array

struct BreedDetails: Decodable, Hashable {
    
    let id: String
    let name: String
    let description: String
    let origin: String
    let temperament: String
    let lifeSpan: String
    let wikipediaURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case origin
        case temperament
        case lifeSpan = "life_span"
        case wikipediaURL = "wikipedia_url"
    }
}
