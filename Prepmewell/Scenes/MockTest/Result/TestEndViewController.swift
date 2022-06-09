//
//  TestEndViewController.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 26/04/2022.
//

import UIKit

class TestEndViewController: UIViewController {
    
    var testResult: TestResult? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customBackButton = UIBarButtonItem(image: UIImage(named: "close-white") , style: .plain, target: self, action: #selector(backAction(sender:)))
        customBackButton.imageInsets = UIEdgeInsets(top: 2, left: -8, bottom: 0, right: 0)
        navigationItem.leftBarButtonItem = customBackButton

        // Do any additional setup after loading the view.
    }
    
    @objc func backAction(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

}
