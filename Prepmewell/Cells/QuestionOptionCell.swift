//
//  QuestionOptionCell.swift
//  Prepmewell
//
//  Created by ari on 8/21/21.
//

import UIKit
import BEMCheckBox

class QuestionOptionCell: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var checkBoxView: BEMCheckBox!
    
    var questionFk: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.translatesAutoresizingMaskIntoConstraints = false
             
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        checkBoxView.onAnimationType = BEMAnimationType.fill
        checkBoxView.offAnimationType = BEMAnimationType.bounce
        checkBoxView.delegate = self
    }
    
    var questionOption: QuestionOption?  {
        didSet {
            if let questionOption = questionOption {
                textLabel.text = questionOption.getName()
                checkBoxView.on = false
            }
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func setAnswer(answer: String?) {
        if answer != nil && !answer!.isEmpty {
            if questionOption?.optionName == answer {
                checkBoxView.on = true
            }
        }
    }
}

extension QuestionOptionCell: BEMCheckBoxDelegate {
    
    func didTap(_ checkBox: BEMCheckBox) {
        if checkBox.on {
            let answer: [Int: String?] = [questionFk: questionOption!.optionName]
            NotificationCenter.default.post(
                name: .didPostQuestionAnswer,
                object: self,
                userInfo: ["Answer" : answer])
        }
    }
    
}
