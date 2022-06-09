//
//  ScheduleCreate.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 06/04/2022.
//

import Foundation

struct ScheduleUpdate: Codable {
    var recordNo, testTypeFK, mockTestFK, status: Int?
    var testTypeName, mockTestName, phoneNumber, mockTypeName, dateTime, email: String?
    var mockTypeFK, studentFK: Int?
    var scheduleTime: String?
    
    init() {
        
    }
    
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
    }
    
    mutating func setScheduleData(schedule: Schedule) {
        self.testTypeFK = schedule.testTypeFK
        self.recordNo = schedule.recordNo
        self.testTypeName = schedule.testTypeName
        self.mockTestFK = schedule.mockTestFK
        self.mockTestName = schedule.mockTestName
        self.mockTypeName = schedule.mockTypeName
        self.dateTime = schedule.dateTime
        self.phoneNumber = "\(schedule.phoneNumber)"
        self.email = schedule.email
        self.status = schedule.status
        self.mockTypeFK = schedule.mockTypeFK
        self.studentFK = schedule.studentFK
        self.scheduleTime = schedule.scheduleTime
    }
}
