//
//  TestResult.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 11/02/2022.
//

import UIKit

struct TestResult: Codable {
    let totalRecords, questionAttempt, correctAnswer: Int?
    let studentFk, recordNo: Int
    let createdOn: String
    let updatedOn: String?
    let startTime, endTime, testTypeName, mockTypeName: String?
    let mockTestFk, totalQuestion: Int?
    let accuracy: Double?
    let totalTimeSpent: Int?
    let totalTimeSpent2: String?
    let achievedBandScore: Double?
    let writingType: String?
    let scheduleTestFK, mockTestProcessingSortOrder: Int?
    let writingTypeFK: Int?
    let duration: Int?
    let testName: String?
    let mockTestResultDetail: [MockTestResultDetail]?
    let mockTest: MockTest?

    enum CodingKeys: String, CodingKey {
        case totalRecords = "TotalRecords"
        case recordNo = "RecordNo"
        case studentFk = "StudentFk"
        case questionAttempt = "QuestionAttempt"
        case correctAnswer = "CorrectAnswer"
        case createdOn = "CreatedOn"
        case updatedOn = "UpdatedOn"
        case startTime = "StartTime"
        case endTime = "EndTime"
        case mockTestFk = "MockTestFk"
        case totalQuestion = "TotalQuestion"
        case accuracy = "Accuracy"
        case totalTimeSpent = "TotalTimeSpent"
        case totalTimeSpent2 = "TotalTimeSpent2"
        case achievedBandScore = "AchievedBandScore"
        case writingType = "WritingType"
        case scheduleTestFK = "ScheduleTestFK"
        case mockTestProcessingSortOrder = "MockTestProcessingSortOrder"
        case writingTypeFK = "WritingTypeFK"
        case duration = "Duration"
        case testName = "TestName"
        case testTypeName = "TestTypeName"
        case mockTypeName = "MockTypeName"
        case mockTestResultDetail = "MockTestResultDetail"
        case mockTest = "MockTest"
    }
    
    func getIcon()-> UIImage {
        switch testTypeName {
            case "Listening":
                return #imageLiteral(resourceName: "audio-fill")
            case "Speaking":
                return #imageLiteral(resourceName: "mic-fill")
            case "Reading":
                return #imageLiteral(resourceName: "book-fill")
            default:
                return #imageLiteral(resourceName: "edit-fill")
        }
    }
}
