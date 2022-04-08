//
//  Schedule.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 06/04/2022.
//

import Foundation

struct Schedule: Codable {
    let testTypeName, mockTestName, mockTypeName: String?
    let duration, targetScore: Int?
    let recordNo, testTypeFK, mockTestFK: Int
    let phoneNumber: Int
    let email: String?
    let status, mockTypeFK, studentFK: Int
    let scheduleTime, dateTime: String
    let createdOn: String
    
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
    
    func getDurationTime()-> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let scheduleTime = dateFormatter.date(from: self.scheduleTime)
        if scheduleTime != nil {
            let endDate = scheduleTime!.adding(minutes: duration ?? 0)

            return "\(scheduleTime!.getFormattedDate(format: "HH:mm aaa")) - \(endDate.getFormattedDate(format: "HH:mm aaa"))"
        }
        return nil
    }

    func getStartTime()-> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        guard let scheduleTime = dateFormatter.date(from: self.scheduleTime) else {
            return nil
        }
        return scheduleTime.getFormattedDate(format: "HH:mm aaa")
    }
    
    func getScheduleTime() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        guard let scheduleTime = dateFormatter.date(from: self.scheduleTime) else {
            return nil
        }
        return scheduleTime
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
