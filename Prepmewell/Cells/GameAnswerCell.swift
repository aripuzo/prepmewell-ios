//
//  GameAnswerCell.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 31/03/2022.
//

import UIKit

class GameAnswerCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var iconView: UIImageView!
    
    func setQuestionItem(item: QuestionOption, myAnswer: String?, currentAnswer: GameAnswer?) {
        cardView.backgroundColor = UIColor(named: "Light blue")
        iconView.isHidden = true
        if(myAnswer == item.optionName) {
            iconView.isHidden = false
            if(currentAnswer?.isCorrect == true) {
                iconView.image = UIImage(named: "correct")
                cardView.backgroundColor = UIColor(named: "Correct question")
            }
            else {
                iconView.image = UIImage(named: "incorrect")
                cardView.backgroundColor = UIColor(named: "Fail question")
            }
        }
        if(currentAnswer?.answer == item.optionName) {
            iconView.isHidden = false
            iconView.image = UIImage(named: "correct")
            cardView.backgroundColor = UIColor(named: "Correct question")
        }
        titleLabel.text = item.optionName
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
