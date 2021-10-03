//
//  SplashViewController.swift
//  Prepmewell
//
//  Created by ari on 8/13/21.
//

import UIKit
import SwiftyUserDefaults

class SplashViewController: UIViewController {

  
    var gameTimer: Timer!
    var splashImageView = UIImageView()

    override func viewDidLoad() {

        super.viewDidLoad()
        navigationBar()
        gameTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(timeaction), userInfo: nil, repeats: true)

    }
    
    func navigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @objc func timeaction(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var id = ""
        if !Defaults[\.isLoggedIn] || Defaults[\.token] == nil {
            id = ScreenID.AUTH
        }
        else{
            id = ScreenID.MAIN
        }
        let controller = storyboard.instantiateViewController(withIdentifier: id)
        sceneDelegate?.window?.rootViewController = controller
        gameTimer.invalidate()
    }
}
