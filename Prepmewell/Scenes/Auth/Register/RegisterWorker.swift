//
//  RegisterWorker.swift
//  Prepmewell
//
//  Created by ari on 8/16/21.
//

import Foundation

protocol RegisterProtocol {
    func register(data: RegisterModel, success: @escaping (DataResponse<RegisterResponse>) -> (), failure: @escaping (String) -> ())
}

class RegisterWorker: RegisterProtocol {
    var networkClient: SignupApiClient?

    func register(data: RegisterModel, success: @escaping (DataResponse<RegisterResponse>) -> (), failure: @escaping (String) -> ()) {
        
        networkClient?.execute(requestType: .post, url: "\(Constants.URL)api/Account/Register", params: ["Email": data.email, "Password": data.password, "ConfirmPassword": data.password, "RoleName": "Student", "FirstName": nil, "LastName": nil, "Gender": nil, "Address": nil, "PhoneNumber": nil, "DateOfBirth": nil]) {(feedback: DataResponse<RegisterResponse>) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
}
