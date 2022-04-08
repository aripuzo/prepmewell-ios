//
//  MockTest.swift
//  Prepmewell
//
//  Created by ari on 8/19/21.
//

import Foundation

class MockTest: NSObject, Codable {
    let mockType: MockType?
    let testType: TestType?
    let recordNo: Int
    let question: [QuestionGroup]?
    let testName: String
    let mockTestDescription, subTitle, guid, totalTime, letterGuide, sampleEssay, createdOn: String?
    let mockTypeFK, testTypeFk: Int
    let freeMockTest, isLocked, isMockTestGiven: Bool?
    let targetScore, bandScore, accuracy: Double?
    let duration, planSortOrder: Int?

    enum CodingKeys: String, CodingKey {
        case mockType = "MockType"
        case question = "Question"
        case testType = "TestType"
        case recordNo = "RecordNo"
        case testName = "TestName"
        case mockTestDescription = "Description"
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
        case bandScore = "BandScore"
        case totalTime = "TotalTime"
        case accuracy = "Accuracy"
        case isLocked = "IsLocked"
        case isMockTestGiven = "IsMockTestGiven"
    }
    
    public override var description: String {
        return testName
    }
}

// MARK: - TestType
class TestType: NSObject, Codable {
    let recordNo: Int
    let testTypeName: String
    let sortOrder: Int
    let isStudent: Bool

    enum CodingKeys: String, CodingKey {
        case recordNo = "RecordNo"
        case testTypeName = "TestTypeName"
        case sortOrder = "SortOrder"
        case isStudent = "IsStudent"
    }
    
    public override var description: String {
        return testTypeName
    }
}

// MARK: - MockType
struct MockType: Codable {
    let recordNo: Int
    let mockTypeName: String

    enum CodingKeys: String, CodingKey {
        case recordNo = "RecordNo"
        case mockTypeName = "MockTypeName"
    }
}
