//
//  TestResultResponse.swift
//  Prepmewell
//
//  Created by ari on 8/20/21.
//

import Foundation

// MARK: - Response
struct TestResultResponse: Codable {
    
}

struct UploadTestResponse: Codable {
    let message: String?
    let status: Bool?
    let answer: String?
    let name: String
        
    enum CodingKeys: String, CodingKey {
        case message
        case status
        case name
        case answer
    }
}
