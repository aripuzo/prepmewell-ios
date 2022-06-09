//
//  TestResultCell.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 09/04/2022.
//

import UIKit

class TestResultCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var yourAnswerButton: CardView!
    @IBOutlet weak var correctAnswerButton: CardView!
    @IBOutlet weak var speakingStack: UIStackView!
    @IBOutlet weak var readingStack: UIStackView!
    
    var question: MockTestResultDetail?
    
    func setDetail(item: MockTestResultDetail, testTypeFk: Int) {
        question = item
        positionLabel.text = "\(item.sortOrder)"
        
        if item.givenAnswer == item.correctAnswer {
            cardView.backgroundColor = UIColor(named: "Cool red")
        } else {
            cardView.backgroundColor = UIColor(named: "Fail question")
        }
        
        if testTypeFk == Constants.TEST_TYPE_SPEAKING {
            titleLabel.text = "\(item.question.questionName!)"
            speakingStack.isHidden = false
            readingStack.isHidden = true
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(didPressYourAnswerBtn))
            yourAnswerButton.addGestureRecognizer(tap)
            
            let tap2 = UITapGestureRecognizer(target: self, action: #selector(didPressCorrectAnswerBtn))
            correctAnswerButton.addGestureRecognizer(tap2)
        }
        else {
            titleLabel.text = "\(item.givenAnswer): \(item.correctAnswer)"
            speakingStack.isHidden = true
            readingStack.isHidden = false
        }
    }
    
    @objc func didPressYourAnswerBtn() {
        
    }
    
    @objc func didPressCorrectAnswerBtn() {
        
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
