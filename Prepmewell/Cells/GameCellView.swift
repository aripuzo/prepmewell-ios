//
//  GameCellView.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 30/03/2022.
//

import UIKit

class GameCellView: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleileLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    
    var game: Game?  {
        didSet {
            if let game = game {
                titleLabel.text = game.testName
                subtitleileLabel.text = game.description
                iconImage.image = game.getImage()
            }
        }
    }
}
