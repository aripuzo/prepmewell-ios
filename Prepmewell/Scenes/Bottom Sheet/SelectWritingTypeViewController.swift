//
//  SelectWritingTypeViewController.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 08/10/2021.
//

import UIKit

class SelectWritingTypeViewController: UIViewController {
    
    //var sheetCoordinator: UBottomSheetCoordinator?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //sheetCoordinator?.startTracking(item: self)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //sheetCoordinator = UBottomSheetCoordinator(parent: self)

//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectWritingTypeViewController") as! SelectWritingTypeViewController

//        vc.sheetCoordinator = sheetCoordinator

        //sheetCoordinator.addSheet(vc, to: self)
    }

}
