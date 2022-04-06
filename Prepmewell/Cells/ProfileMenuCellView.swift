//
//  ProfileMenuCellView.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 11/02/2022.
//

import UIKit

class ProfileMenuCellView: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var item: ProfileMenuItem?  {
        didSet {
            if let item = item {
                titleLabel.text = item.name
                icon.image = item.icon
            }
        }
    }
}
