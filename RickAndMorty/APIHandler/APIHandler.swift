//
//  APIHandler.swift
//  RickAndMorty
//
//  Created by Hugo Huichalao on 06-07-24.
//

import Foundation


protocol CharacterService {
    func fetchCharacters(completion: @escaping (Result<[Character], Error>) -> Void)
    func fetchCharacterDetails(id: Int, completion: @escaping (Result<Character, Error>) -> Void)
    func fetchEpisodes(from urls: [String], completion: @escaping (Result<[Episode], Error>) -> Void)
}

class APIHandler: CharacterService {
    static let shared = APIHandler()

    private init() {}

    func fetchCharacters(completion: @escaping (Result<[Character], Error>) -> Void) {
        let urlString = "https://rickandmortyapi.com/api/character"

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching characters: \(error)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data returned")
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }

            do {
                let decoder = JSONDecoder()
                let characterResponse = try decoder.decode(CharacterResponse.self, from: data)
                completion(.success(characterResponse.results))
            } catch {
                print("Error decoding JSON: \(error)")
                completion(.failure(error))
            }
        }

        task.resume()
    }

    func fetchCharacterDetails(id: Int, completion: @escaping (Result<Character, Error>) -> Void) {
        let urlString = "https://rickandmortyapi.com/api/character/\(id)"
        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching character details: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data returned")
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }

            do {
                let decoder = JSONDecoder()
                let character = try decoder.decode(Character.self, from: data)
                completion(.success(character))
            } catch {
                print("Error decoding character details: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }

        task.resume()
    }

    func fetchEpisodes(from urls: [String], completion: @escaping (Result<[Episode], Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        var fetchedEpisodes: [Episode] = []
        var fetchError: Error?

        for urlString in urls {
            guard let url = URL(string: urlString) else { continue }

            dispatchGroup.enter()

            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error fetching episode: \(error.localizedDescription)")
                    fetchError = error
                    dispatchGroup.leave()
                    return
                }

                guard let data = data else {
                    print("No data returned for episode")
                    fetchError = NSError(domain: "No data", code: -1, userInfo: nil)
                    dispatchGroup.leave()
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let episode = try decoder.decode(Episode.self, from: data)
                    fetchedEpisodes.append(episode)
                } catch {
                    print("Error decoding episode: \(error.localizedDescription)")
                    fetchError = error
                }

                dispatchGroup.leave()
            }.resume()
        }

        dispatchGroup.notify(queue: .main) {
            if let error = fetchError {
                completion(.failure(error))
            } else {
                completion(.success(fetchedEpisodes))
            }
        }
    }
}
