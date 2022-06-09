//
//  PlanCellView.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 01/06/2022.
//

import UIKit

class PlanCellView: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var planButton: DesignableButton!
    
    var questionFk: Int!
    var choosePlan: () -> Void = { }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.choosePlanClicked))
        planButton.addGestureRecognizer(tap)
        planButton.isUserInteractionEnabled = true
    }
    
    func setPlan(plan: Plan, isActive: Bool, isPayable: Bool) {
        titleLabel.text = plan.planName
        priceLabel.text = "\(plan.cost)"
        planButton.isEnabled = isPayable
        let title = isActive ? "Active plan" : "Choose this plan"
        let color = isActive ? "Light blue" : "Accent"
        planButton.setTitle(title, for: .normal)
        planButton.color = UIColor(named: color)!
    }
    
    @objc func choosePlanClicked(sender: UIButton!) {
        choosePlan()
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
