//
//  LoginInteractor.swift
//  BabyBliss
//
//  Created by Ugo Val on 3/2/21.
//

import Foundation

protocol LoginBusinessLogic {
    func login(data: LoginModel)
}

class LoginInteractor: LoginBusinessLogic {
    var presenter: LoginPresentationLogic?
    var loginWorker: LoginProtocol?

    func login(data: LoginModel) {
        loginWorker?.login(data: data, success: { (feedback) in
            self.presenter?.displayLogin(alert: feedback)
        }, failure: { (error) in
            self.presenter?.displayLoginError(alert: error)
        })
    }
}
