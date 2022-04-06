//
//  RegisterModel.swift
//  Prepmewell
//
//  Created by ari on 8/16/21.
//

import Foundation

struct RegisterModel: Codable {
    var email, password: String

    enum CodingKeys: String, CodingKey {
        case email = "Email"
        case password = "Password"
    }
}
