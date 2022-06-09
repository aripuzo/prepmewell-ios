//
//  Plan.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 01/06/2022.
//

import Foundation

// MARK: - Welcome
struct UserPlan: Codable {
    var recordNo: Int?
    var planFK: Int
    var plan: Plan?
    var startDate, endDate: String?
    var transactionID, status: String?
    var currency, productName, name, email: String?
    var address: String?
    var amount: Double?
    var merchantID: String?
    var orderNo: Int?
    var subscriptionID, reason, reasonDescription, feedback: String?
    var cancelledOn: String?
    var isCancelled: Bool?
    var mockTypeFK, mockTestFK: Int?
    
    func isExpired() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        guard let expiriyTime = dateFormatter.date(from: self.endDate!) else {
            return false
        }
        return Date() > expiriyTime
    }

    enum CodingKeys: String, CodingKey {
        case recordNo = "RecordNo"
        case planFK = "PlanFK"
        case plan = "Plan"
        case startDate = "StartDate"
        case endDate = "EndDate"
        case transactionID = "TransactionId"
        case status = "Status"
        case currency = "Currency"
        case productName = "ProductName"
        case name = "Name"
        case email = "Email"
        case address = "Address"
        case amount = "Amount"
        case merchantID = "MerchantId"
        case orderNo = "OrderNo"
        case subscriptionID = "SubscriptionID"
        case reason = "Reason"
        case reasonDescription = "ReasonDescription"
        case feedback = "Feedback"
        case cancelledOn = "CancelledOn"
        case isCancelled = "IsCancelled"
        case mockTypeFK = "MockTypeFK"
        case mockTestFK = "MockTestFK"
    }
}

// MARK: - Plan
struct Plan: Codable {
    let recordNo: Int
    let planName: String
    let cost: Double
    let period: Int
    let desc: String?
    let discount: Double
    let markerFees, leadMarkerFees, sortOrder: Int
    let createdOn: String

    enum CodingKeys: String, CodingKey {
        case recordNo = "RecordNo"
        case planName = "PlanName"
        case cost = "Cost"
        case period = "Period"
        case desc = "Description"
        case discount = "Discount"
        case markerFees = "MarkerFees"
        case leadMarkerFees = "LeadMarkerFees"
        case sortOrder = "SortOrder"
        case createdOn = "CreatedOn"
    }
}

struct UserPlanUpdate: Codable {
    var planFK: Int
    var transactionID: String?
    var currency, productName, name: String?
    var amount: Double?
    var merchantID: String?
    var orderNo: Int?
    var subscriptionID: String?

    enum CodingKeys: String, CodingKey {
        case planFK = "PlanFK"
        case transactionID = "TransactionId"
        case currency = "Currency"
        case productName = "ProductName"
        case name = "Name"
        case amount = "Amount"
        case merchantID = "MerchantId"
        case orderNo = "OrderNo"
        case subscriptionID = "SubscriptionID"
    }
}
