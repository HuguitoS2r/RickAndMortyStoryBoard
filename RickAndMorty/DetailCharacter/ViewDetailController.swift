//
//  ViewDetailController.swift
//  RickAndMorty
//
//  Created by Hugo Huichalao on 30-06-24.
//

import UIKit

class ViewDetailController: UIViewController{
    
    var characterId: Int?
    var character: Character?
    var episodes: [Episode] = []
    private var characterService: CharacterService = APIHandler.shared
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id = characterId {
            fetchCharacterDetails(id: id)
        }
        
        let header = UIView(frame: CGRect(x:0, y:0, width: view.frame.size.width, height: 50))
        let footer = UIView(frame: CGRect(x:0, y:0, width: view.frame.size.width, height: 20))
        
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 10, width: header.frame.size.width - 20, height: 40))
        headerLabel.text = "Episodes"
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        headerLabel.textColor = .systemGreen
        headerLabel.shadowColor = .yellow
        headerLabel.shadowOffset = CGSize(width: 4, height: 4)
        header.addSubview(headerLabel)
        tableView.tableHeaderView = header
        
        let footerLabel = UILabel(frame: CGRect(x: 10, y: 10, width: header.frame.size.width - 20, height: 20))
        footerLabel.text = "By HuguitoDev"
        footerLabel.textAlignment = .center
        footerLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        footerLabel.textColor = .systemGreen
        footerLabel.shadowColor = .yellow
        footerLabel.shadowOffset = CGSize(width: 4, height: 4)
        footer.addSubview(footerLabel)
        tableView.tableFooterView = footerLabel
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "EpisodeTableViewCell", bundle: nil), forCellReuseIdentifier: "EpisodeCell")        
    }
    
    private func fetchCharacterDetails(id: Int) {
            characterService.fetchCharacterDetails(id: id) { [weak self] result in
                switch result {
                case .success(let character):
                    DispatchQueue.main.async {
                        self?.updateUI(with: character)
                    }
                case .failure(let error):
                    print("Failed to fetch character details: (error)")
                }
            }
        }
    
    private func updateUI(with character: Character) {
        self.character = character
        nameLabel.text = character.name
        statusLabel.text = character.status
        speciesLabel.text = character.species
        genderLabel.text = character.gender
        if let url = URL(string: character.image) {
            imageView.loadImage(from: url)
        }
        fetchEpisodes(from: character.episode)
    }
    
    private func fetchEpisodes(from urls: [String]) {
        self.characterService.fetchEpisodes(from: urls) { [weak self] result in
                switch result {
                case .success(let episodes):
                    self?.episodes = episodes
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Failed to fetch episodes: (error)")
                }
            }
        }
}

extension ViewDetailController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath) as? EpisodeTableViewCell else {
            fatalError("Unable to dequeue EpisodeTableViewCell")
        }
        
        let episode = episodes[indexPath.row]
        cell.configure(with: episode)
        
        return cell
    }
}

extension UIImageView {
    func loadImage(from url: URL) {
        self.image = UIImage(systemName: "photo")

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("No image data found")
                return
            }

            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}


