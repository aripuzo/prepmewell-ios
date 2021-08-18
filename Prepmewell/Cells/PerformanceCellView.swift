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
}
