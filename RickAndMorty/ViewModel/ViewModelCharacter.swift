//
//  ViewModelCharacter.swift
//  RickAndMorty
//
//  Created by Hugo Huichalao on 18-06-24.
//

import Foundation

class CharactersViewModel {
    var characters: [Character] = []
    var onUpdate: (() -> Void)?

    func fetchCharacters() {
        APIHandler.shared.fetchCharacters { [weak self] result in
            switch result {
            case .success(let characters):
                self?.characters = characters
                DispatchQueue.main.async {
                    self?.onUpdate?()
                }
            case .failure(let error):
                print("Error fetching characters: (error)")
            }
        }
    }
}

