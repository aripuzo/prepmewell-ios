//
//  QuestionnaireCellView.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 19/03/2022.
//

import UIKit

class QuestionnaireCellView: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    var text: String?  {
        didSet {
            nameLabel.text = text
        }
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
