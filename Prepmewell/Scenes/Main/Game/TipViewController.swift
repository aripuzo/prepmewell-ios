//
//  TipViewController.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 05/04/2022.
//

import UIKit
import XLPagerTabStrip

class TipViewController: UIViewController, IndicatorInfoProvider {
    
    var header: String!
    var body: String!
    var info: String!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = header
        bodyLabel.text = body
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: info)
    }

}
