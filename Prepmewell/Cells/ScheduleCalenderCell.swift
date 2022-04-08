//
//  ScheduleCalenderCell.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 07/04/2022.
//

import UIKit

class ScheduleCalenderView: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    }
    
    let dateFormatter = DateFormatter()
    
    
    func setDate(date: Date, isSelected: Bool, schedules: [Schedule]?) {
        if !isSelected {
            dayLabel.textColor = UIColor(named: "Text1")
            dateLabel.textColor = UIColor(named: "Text2")
            cardView.backgroundColor = .white
        }
        else {
            dayLabel.textColor = .white
            dateLabel.textColor = .white
            cardView.backgroundColor = UIColor(named: "Accent")
        }
        
        dateFormatter.dateFormat = "E"
        dayLabel.text = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "dd"
        dateLabel.text = dateFormatter.string(from: date)
        
        for view in self.stackView.subviews {
            view.removeFromSuperview()
        }
        
        schedules?.forEach { schedule in
            stackView.addArrangedSubview(getScheduleView(schedule: schedule))
        }
    }
    
    func getScheduleView(schedule: Schedule) -> UIView {
        let view = CardView()
        view.cornerRadius = 4
        view.borderColor = .white
        view.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 8).isActive = true
        view.widthAnchor.constraint(equalToConstant: 8).isActive = true
        switch schedule.status {
        case 1:
            view.backgroundColor = UIColor(named: "Test taken")
            break;
        case 2:
            view.backgroundColor = UIColor(named: "Test missed")
            break;
        default:
            view.backgroundColor = UIColor(named: "Test pending")
        }
        return view
    }
}
