//
//  ResetPasswordInteractor.swift
//  Prepmewell
//
//  Created by ari on 8/15/21.
//

import Foundation

protocol ResetPasswordBusinessLogic {
    func resetPassword(email: String)
}

class ResetPasswordInteractor: ResetPasswordBusinessLogic {
    var presenter: ResetPasswordPresentationLogic?
    var resetPasswordWorker: ResetPasswordProtocol?

    func resetPassword(email: String) {
        resetPasswordWorker?.resetPassword(email: email, success: { (feedback) in
            self.presenter?.displayResponse(response: feedback)
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
}
