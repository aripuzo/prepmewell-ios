//
//  PerformanceCellView.swift
//  Prepmewell
//
//  Created by ari on 8/18/21.
//

import UIKit

class PerformanceCellView: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var totalTestLabel: UILabel!
    @IBOutlet weak var totalQuestionLabel: UILabel!
    @IBOutlet weak var correctQuestionLabel: UILabel!
    @IBOutlet weak var incorrectQuestionLabel: UILabel!
    @IBOutlet weak var unAnsweredLabel: UILabel!
    @IBOutlet weak var averageTimeLabel: UILabel!
    
    var performance: Performance?  {
        didSet {
            if performance != nil {
                titleLabel.text = "\(performance!.testTypeName) Test"
                totalTestLabel.text = "\(performance!.totalTestTaken)"
                totalQuestionLabel.text = "\(performance!.totalQuestion)"
                correctQuestionLabel.text = "\(performance!.correctQuestion)"
                incorrectQuestionLabel.text = "\(performance!.incorrectQuestion)"
                unAnsweredLabel.text = "\(performance!.unanswerQuestion)"
                averageTimeLabel.text = performance!.averageTime
                icon.image = performance!.getIcon()
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
