//
//  MainTabViewController.swift
//  Prepmewell
//
//  Created by ari on 8/13/21.
//

import UIKit
import RAMAnimatedTabBarController

class MainTabViewController: RAMAnimatedTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func gotoTab(selction: Int){
        tabBarController?.selectedIndex = selction
    }
    
}
