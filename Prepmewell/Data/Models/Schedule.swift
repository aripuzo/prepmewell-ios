//
//  Schedule.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 06/04/2022.
//

import Foundation

struct Schedule: Codable {
    let recordNo: Int
    let testTypeFK: Int
    let testTypeName: String
    let mockTestFK: Int
    let mockTestName: String
    let mockTypeName: String
    let dateTime: String
    let phoneNumber: Int
    let email: String
    let status: Int
    let mockTypeFK: Int
    let studentFK: Int
    let scheduleTime: Date
    let createdOn: String
    let targetScore: Int
    let duration: Int
    
    enum CodingKeys: String, CodingKey {
        case testTypeFK = "TestTypeFK"
        case recordNo = "RecordNo"
        case testTypeName = "TestTypeName"
        case mockTestFK = "MockTestFK"
        case mockTestName = "MockTestName"
        case mockTypeName = "MockTypeName"
        case dateTime = "DateTime"
        case phoneNumber = "PhoneNumber"
        case email = "Email"
        case status = "Status"
        case mockTypeFK = "MockTypeFK"
        case studentFK = "StudentFK"
        case scheduleTime = "ScheduleTime"
        case createdOn = "CreatedOn"
        case targetScore = "TargetScore"
        case duration = "Duration"
    }
    
    func getDurationTime()-> String {
        let endDate = scheduleTime.adding(minutes: duration)

        return "\(scheduleTime.getFormattedDate(format: "HH:mm aaa")) - \(endDate.getFormattedDate(format: "HH:mm aaa"))"
    }

    func getStartTime()-> String {
        return scheduleTime.getFormattedDate(format: "HH:mm aaa")
    }
}

struct ScheduleDataResponse: Codable {
    let pending: [Schedule]
    let missed: [Schedule]
    let taken: [Schedule]
    
    enum CodingKeys: String, CodingKey {
        case pending = "Pending"
        case missed = "Missed"
        case taken = "Taken"
    }
}
