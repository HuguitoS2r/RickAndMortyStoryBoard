//
//  Character.swift
//  RickAndMorty
//
//  Created by Hugo Huichalao on 18-06-24.
//

import Foundation

struct CharacterResponse: Codable {
    let results: [Character]
}

struct Character: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

struct Episode: Codable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case airDate = "air_date"
        case episode
    }
}

