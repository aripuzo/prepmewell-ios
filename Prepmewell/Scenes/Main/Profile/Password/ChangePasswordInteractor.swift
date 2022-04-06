//
//  ChangePasswordInteractor.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 11/02/2022.
//

import Foundation

protocol ChangePasswordBusinessLogic {
    func updatePassword(data: ChangePassword)
}

class ChangePasswordInteractor: ChangePasswordBusinessLogic {
    var presenter: ChangePasswordPresentationLogic?
    var worker: ChangePasswordProtocol?

    func updatePassword(data: ChangePassword) {
        worker?.updatePassword(data: data, success: { (feedback) in
            self.presenter?.displayUpdateResult(result: feedback)
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
}
