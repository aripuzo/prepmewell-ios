//
//  ErrorMessage.swift
//  Prepmewell
//
//  Created by ari on 8/16/21.
//

import Foundation

struct ErrorMessage: Decodable {
    let response: String?
    let error: String?
    let errors: String?
    let errorDescription: String?
    let messageDetail: String?
    let message: String?
    let message2: String?
    
    enum CodingKeys: String, CodingKey {
        case response
        case error
        case errors = "Errors"
        case errorDescription = "error_description"
        case messageDetail = "MessageDetail"
        case message = "Message"
        case message2 = "message"
    }
    
    func getMessage() -> String {
        if error != nil {
            if error == "unsupported_grant_type" {
                return "Invalid login credentials"
            } else {
                return error!
            }
        }
        if errors != nil {
            return errors!
        }
        if response != nil {
            return response!
        }
        if errorDescription != nil {
            return errorDescription!
        }
        if messageDetail != nil {
            return messageDetail!
        }
        if message != nil {
            return message!
        }
        if message2 != nil {
            return message2!
        }
        return "Error parsing server message"
    }
}
