//
//  HistoryCellView.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 11/02/2022.
//

import UIKit

class HistoryCellView: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    var item: TestResult?  {
        didSet {
            if let item = item {
                titleLabel.text = item.testTypeName! + " " + item.testName!
                subTitleLabel.text = "Bandscore: \(item.achievedBandScore!)"
                icon.image = item.getIcon()
            }
        }
    }
}
