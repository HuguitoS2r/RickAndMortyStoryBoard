//
//  EpisodeTableViewCell.swift
//  RickAndMorty
//
//  Created by Hugo Huichalao on 03-07-24.
//

import UIKit

class EpisodeTableViewCell: UITableViewCell {

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(with episode: Episode) {
        detailLabel.text = episode.name
        nameLabel.text = "\(episode.episode) - \(episode.airDate)"
       }
    
    
    
}
