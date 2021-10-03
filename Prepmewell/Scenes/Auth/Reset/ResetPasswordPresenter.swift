//
//  ResetPasswordPresenter.swift
//  Prepmewell
//
//  Created by ari on 8/15/21.
//

import Foundation

protocol ResetPasswordPresentationLogic {
    func displayResponse(response: StringResponse)
    func displayError(alert: String)
}

class ResetPasswordPresenter: ResetPasswordPresentationLogic {
    var resetView: ResetPasswordDisplayLogic?

    func displayResponse(response: StringResponse) {
        resetView?.displayResponse(response:response)
    }
    
    func displayError(alert: String) {
        resetView?.displayError(alert: alert)
    }
}
