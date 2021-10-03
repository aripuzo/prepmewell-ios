//
//  RegisterInteractor.swift
//  Prepmewell
//
//  Created by ari on 8/16/21.
//

import Foundation

protocol RegisterBusinessLogic {
    func register(data: RegisterModel)
}

class RegisterInteractor: RegisterBusinessLogic {
    var presenter: RegisterPresentationLogic?
    var registerWorker: RegisterProtocol?

    func register(data: RegisterModel) {
        registerWorker?.register(data: data, success: { (feedback) in
            self.presenter?.displayResponse(response: feedback)
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
}
