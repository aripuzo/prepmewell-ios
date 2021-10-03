//
//  LoginModel.swift
//  Prepmewell
//
//  Created by ari on 8/1/21.
//

import Foundation

struct LoginModel: Codable {
    let userName, password: String
    var grant_type = "password"
}
