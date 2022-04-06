//
//  ChangePasswordWorker.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 11/02/2022.
//

import Foundation
import Alamofire

protocol ChangePasswordProtocol {
    func updatePassword(data: ChangePassword, success: @escaping (String) -> (), failure: @escaping (String) -> ())
}

class ChangePasswordWorker: ChangePasswordProtocol {
    var networkClient: PrepmewellApiClient?

    func updatePassword(data: ChangePassword, success: @escaping (String) -> (), failure: @escaping (String) -> ()) {
        
        networkClient?.execute(requestType: .post, url: "\(Constants.URL)api/Account/ChangePassword", params: ["OldPassword": data.oldPassword, "NewPassword": data.newPassword, "ConfirmPassword": data.confirmPassword]) {(feedback: String) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
}
