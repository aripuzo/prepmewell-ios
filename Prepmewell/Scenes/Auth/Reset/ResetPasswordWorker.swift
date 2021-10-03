//
//  ResetPassword.swift
//  Prepmewell
//
//  Created by ari on 8/15/21.
//

import Foundation

protocol ResetPasswordProtocol {
    func resetPassword(email: String, success: @escaping (StringResponse) -> (), failure: @escaping (String) -> ())
}

class ResetPasswordWorker: ResetPasswordProtocol {
    var networkClient: SignupApiClient?

    func resetPassword(email: String, success: @escaping (StringResponse) -> (), failure: @escaping (String) -> ()) {
        networkClient?.execute (requestType: .post, url: "\(Constants.URL)api/Account/EmailForgotPassword", params: ["EmailAddress" : email]) {(feedback: StringResponse) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
}
