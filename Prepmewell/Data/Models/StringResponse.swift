//
//  StringResponse.swift
//  Prepmewell
//
//  Created by ari on 8/15/21.
//

import Foundation

struct StringResponse: Decodable {
    let response: String?
    
    enum CodingKeys: String, CodingKey {
        case response
    }
}
