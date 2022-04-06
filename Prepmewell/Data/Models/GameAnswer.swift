//
//  GameAnswer.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 31/03/2022.
//

import Foundation

struct GameAnswer: Codable {
    let isCorrect: Bool

    let answer: String
    
    enum CodingKeys: String, CodingKey {
        case isCorrect = "IsCorrect"
        case answer = "Answer"
    }
}
