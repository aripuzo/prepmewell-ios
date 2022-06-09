//
//  WrittenHistoryViewController.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 09/04/2022.
//

import UIKit
import XLPagerTabStrip

class WrittenHistoryViewController: UIViewController, IndicatorInfoProvider {
    
    var testResult: TestResult?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "TASK ONE")
    }

}
