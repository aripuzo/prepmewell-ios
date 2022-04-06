//
//  TestResultCell.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 04/04/2022.
//

import UIKit

class GameTestResultCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var cardView: CardView!
    
    var item: MockTestResultDetail?  {
        didSet {
            positionLabel.text = "\(item!.sortOrder)"
            titleLabel.text = "\(item!.correctAnswer)"
            if item!.givenAnswer == item!.correctAnswer {
                cardView.backgroundColor = UIColor(named: "Correct question")
                titleLabel.textColor = UIColor(named: "Correct question")
            } else {
                cardView.backgroundColor = UIColor(named: "Fail question")
                titleLabel.textColor = UIColor(named: "Fail question")
            }
        }
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
