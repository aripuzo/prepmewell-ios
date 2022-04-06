//
//  TokenResponse.swift
//  Prepmewell
//
//  Created by ari on 8/1/21.
//

import Foundation

struct TokenResponse: Codable {
    let accessToken: String?
    let tokenType: String?
    let expiresIn: Int?
    let userName: String?
    let guid: String?
    let issued: String?
    let expires: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case userName = "user_name"
        case guid = "Guid"
        case issued = ".issued"
        case expires = ".expires"
    }
}
