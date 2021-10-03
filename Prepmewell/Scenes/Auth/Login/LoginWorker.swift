//
//  LoginWorker.swift
//  BabyBliss
//
//  Created by Ugo Val on 3/2/21.
//

import Foundation
import Alamofire

protocol LoginProtocol {
    func login(data: LoginModel, success: @escaping (TokenResponse) -> (), failure: @escaping (String) -> ())
}

class LoginWorker: LoginProtocol {
    var networkClient: SignupApiClient?

    func login(data: LoginModel, success: @escaping (TokenResponse) -> (), failure: @escaping (String) -> ()) {
        
        let headers: HTTPHeaders = [
                "Content-Type":"application/x-www-form-urlencoded; charset=UTF-8"]
        
        networkClient?.execute(requestType: .post, url: "\(Constants.URL)token", params: ["userName" : data.userName, "password" : data.password, "grant_type" : "password"], headers: headers, encoding: URLEncoding.default) {(feedback: TokenResponse) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
}
