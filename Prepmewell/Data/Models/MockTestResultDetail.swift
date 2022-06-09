//
//  MockTestResultDetail.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 04/04/2022.
//

import Foundation

struct MockTestResultDetail: Codable {
    let question: Question
    let recordNo: Int
    let mockTestResultFK, sortOrder, questionFk: Int
    let givenAnswer, correctAnswer: String?
    let status: Bool
    let createdOn: String
    let wordCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case question = "Question"
        case recordNo = "RecordNo"
        case mockTestResultFK = "MockTestResultFK"
        case givenAnswer = "GivenAnswer"
        case correctAnswer = "CorrectAnswer"
        case createdOn = "CreatedOn"
        case status = "Status"
        case sortOrder = "SortOrder"
        case wordCount = "WordCount"
        case questionFk = "QuestionFk"
    }
}
