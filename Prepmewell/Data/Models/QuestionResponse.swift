//
//  QuestionResponse.swift
//  Prepmewell
//
//  Created by ari on 8/1/21.
//

import Foundation


// MARK: - Response
struct QuestionResponse: Codable {
    let mockType: MockType
    let question: [QuestionGroup]
    let testType: TestType
    let recordNo: Int
    let testName, responseDescription: String
    let subTitle, guid: String?
    let mockTypeFK, testTypeFk: Int
    let freeMockTest: Bool
    let targetScore: Double
    let duration, planSortOrder: Int
    let createdOn: String
    let letterGuide, sampleEssay: String?

    enum CodingKeys: String, CodingKey {
        case mockType = "MockType"
        case question = "Question"
        case testType = "TestType"
        case recordNo = "RecordNo"
        case testName = "TestName"
        case responseDescription = "Description"
        case subTitle = "SubTitle"
        case guid = "Guid"
        case mockTypeFK = "MockTypeFK"
        case testTypeFk = "TestTypeFk"
        case freeMockTest = "FreeMockTest"
        case targetScore = "TargetScore"
        case duration = "Duration"
        case planSortOrder = "PlanSortOrder"
        case createdOn = "CreatedOn"
        case letterGuide = "LetterGuide"
        case sampleEssay = "SampleEssay"
    }
}

// MARK: - Question
struct QuestionGroup: Codable {
    let mockTestQuestion: [MockTestQuestion]
    let subGroup: [QuestionGroup]
    let recordNo: Int
    let groupName: String
    let mockTestFK: Int
    let questionDescription: String?
    let isNameVisible, isDescriptionVisible: Bool
    let createdOn: String
    let isDeleted: Bool
    let dropDownName: String
    let parentFK: Int?

    enum CodingKeys: String, CodingKey {
        case mockTestQuestion = "MockTestQuestion"
        case subGroup = "SubGroup"
        case recordNo = "RecordNo"
        case groupName = "GroupName"
        case mockTestFK = "MockTestFK"
        case questionDescription = "Description"
        case isNameVisible = "IsNameVisible"
        case isDescriptionVisible = "IsDescriptionVisible"
        case createdOn = "CreatedOn"
        case isDeleted = "IsDeleted"
        case dropDownName = "DropDownName"
        case parentFK = "ParentFK"
    }
}

// MARK: - MockTestQuestion
struct MockTestQuestion: Codable {
    let question: Question
    let recordNo, sortOrder, questionFk, questionGroupFK: Int
    let createdOn: String

    enum CodingKeys: String, CodingKey {
        case question = "Question"
        case recordNo = "RecordNo"
        case sortOrder = "SortOrder"
        case questionFk = "QuestionFk"
        case questionGroupFK = "QuestionGroupFK"
        case createdOn = "CreatedOn"
    }
}

// MARK: - MockTestQuestionQuestion
struct Question: Codable {
    let questionOption: [QuestionOption]
    let recordNo: Int
    let questionName: String?
    let mockTestFK: Int?
    let questionTypeFk: Int
    let explanation: String?
    let createdOn: String
    let dropDownName: String
    let sampleEssay, letterGuide: String?

    enum CodingKeys: String, CodingKey {
        case questionOption = "QuestionOption"
        case recordNo = "RecordNo"
        case questionName = "QuestionName"
        case mockTestFK = "MockTestFK"
        case questionTypeFk = "QuestionTypeFk"
        case explanation = "Explanation"
        case createdOn = "CreatedOn"
        case dropDownName = "DropDownName"
        case sampleEssay = "SampleEssay"
        case letterGuide = "LetterGuide"
    }
}

// MARK: - QuestionOption
struct QuestionOption: Codable {
    let recordNo: Int
    let optionName: String
    let discription: String?
    let isNameVisible, isDiscriptionVisible: Bool
    let questionFK: Int
    let createdOn: String

    enum CodingKeys: String, CodingKey {
        case recordNo = "RecordNo"
        case optionName = "OptionName"
        case discription = "Discription"
        case isNameVisible = "IsNameVisible"
        case isDiscriptionVisible = "IsDiscriptionVisible"
        case questionFK = "QuestionFK"
        case createdOn = "CreatedOn"
    }
    
    func getName()-> String{
        return optionName + ((discription != nil && isDiscriptionVisible) ? ". \(discription ?? "")" : "")
    }
}

// MARK: - QuestionOption
struct QuestionAnswer: Codable {
    let questionFK: Int
    var answer: String?
    var wordCount: Int?

    enum CodingKeys: String, CodingKey {
        case questionFK = "QuestionFK"
        case answer = "Answer"
        case wordCount = "WordCount"
    }
    
    func isAnswered()-> Bool {
        return answer?.isEmpty == false
    }
}
