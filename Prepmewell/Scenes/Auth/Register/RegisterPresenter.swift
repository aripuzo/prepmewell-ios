//
//  RegisterPresenter.swift
//  Prepmewell
//
//  Created by ari on 8/16/21.
//

import Foundation

protocol RegisterPresentationLogic {
    func displayResponse(response: DataResponse<RegisterResponse>)
    func displayError(alert: String)
}

class RegisterPresenter: RegisterPresentationLogic {
    var registerView: RegisterDisplayLogic?

    func displayResponse(response: DataResponse<RegisterResponse>) {
        registerView?.displayResponse(response: response)
    }
    
    func displayError(alert: String) {
        registerView?.displayError(alert: alert)
    }
    
}
