//
//  ChangePassword.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 11/02/2022.
//

import Foundation

struct ChangePassword: Codable {
    let oldPassword, newPassword, confirmPassword: String
    
    enum CodingKeys: String, CodingKey {
        case oldPassword = "OldPassword"
        case newPassword = "NewPassword"
        case confirmPassword = "ConfirmPassword"
    }
}
