//
//  MockTestCell.swift
//  Prepmewell
//
//  Created by ari on 8/19/21.
//

import UIKit

class MockTestCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bandScoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bandScoreTitleLabel: UILabel!
    @IBOutlet weak var timeTileLabel: UILabel!
    @IBOutlet weak var lockImage: UIImageView!
    @IBOutlet weak var cardView: UIView!
    
    
    var mockTest: MockTest?  {
        didSet {
            if let mockTest = mockTest {
                titleLabel.text = "Mock Test: \(mockTest.testName)"
                bandScoreLabel.text = "\(mockTest.bandScore!)"
                timeLabel.text = "\(mockTest.totalTime!)"
                
                bandScoreLabel.isHidden = mockTest.isLocked == true
                bandScoreTitleLabel.isHidden = mockTest.isLocked == true
                timeLabel.isHidden = mockTest.isLocked == true
                timeTileLabel.isHidden = mockTest.isLocked == true
                lockImage.isHidden = mockTest.isLocked != true
                
                titleLabel.textColor = mockTest.isLocked == true ? UIColor.white : UIColor(named: "Text1")
                
                cardView.backgroundColor = mockTest.isLocked == true ? UIColor(named: "Accent") : UIColor.white
            }
        }
    }
}
