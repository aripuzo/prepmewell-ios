//
//  DashboardMenuCellView.swift
//  Prepmewell
//
//  Created by ari on 8/18/21.
//

import UIKit

class DashboardMenuCellView: UITableViewCell {
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

struct ProfileMenuItem {
    let name: String
    let icon: UIImage
}
