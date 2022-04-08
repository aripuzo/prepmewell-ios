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
}
