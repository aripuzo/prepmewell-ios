//
//  LoginPresenter.swift
//  BabyBliss
//
//  Created by Ugo Val on 3/2/21.
//

import Foundation

protocol LoginPresentationLogic {
    func displayLogin(alert: TokenResponse)
    func displayLoginError(alert: String)
}

class LoginPresenter:LoginPresentationLogic {
    var loginView: LoginDisplayLogic?

    func displayLogin(alert: TokenResponse) {
        loginView?.displayAlert(response: alert)
    }
    
    func displayLoginError(alert: String) {
        loginView?.displayError(alert: alert)
    }
    
}
