//
//  ChangePasswordPresenter.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 11/02/2022.
//

import Foundation

protocol ChangePasswordPresentationLogic {
    func displayUpdateResult(result: String)
    func displayError(alert: String)
}

class ChangePasswordPresenter: ChangePasswordPresentationLogic {
    func displayError(alert: String) {
            homeView?.displayError(alert: alert)
    }
    
    func displayUpdateResult(result: String) {
        homeView?.displayUpdateResult(resut: result)
    }
    
    var homeView: ChangePasswordDisplayLogic?
    
}
