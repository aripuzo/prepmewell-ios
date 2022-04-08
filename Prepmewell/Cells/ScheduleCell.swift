//
//  ScheduleCell.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 06/04/2022.
//

import UIKit

class ScheduleCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var indicatorView: UIView!
    
    var item: Schedule?  {
        didSet {
            timeLabel.text = item!.getStartTime()
            titleLabel.text = "\(item!.testTypeName!) Test: \(item!.mockTestName!)"
            durationLabel.text = item!.getDurationTime()
            
            switch item?.status {
            case 1:
                indicatorView.backgroundColor = UIColor(named: "Test taken")
                break;
            case 2:
                indicatorView.backgroundColor = UIColor(named: "Test missed")
                break;
            default:
                indicatorView.backgroundColor = UIColor(named: "Test pending")
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
