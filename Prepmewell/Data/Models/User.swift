//
//  User.swift
//  Prepmewell
//
//  Created by ari on 8/1/21.
//

import SwiftyUserDefaults

struct User: Codable, DefaultsSerializable {
    let id: Int
    let lastName, firstName: String
    let hasRegistered, emailConfirmed: Bool
    let fullName, dateOfBirth : String?
    let gender: String
    let countryFK: Int
    let email: String
    let address, stateFK, occupationFK: Int?
    let phoneNumber: String
    let isStudentRole, isMarkerRole, isAdminRole, isLeadMarkerRole: Bool
    let userName: String
    let isAllowNotificationsViaPopUPS, isAllowNotificationsViaEmail, isAllowNotificationsViaSMS, isAllowNotificationsForRating: Bool
    let isAllowNotificationsForNewsAndAnnoucements, isAllowNotificationsForNewsletter, isAllowNotificationsForMonthlyAccountStatement: Bool
    let location: String
    let displayName: String?
    let countryCode: String
    
    

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case lastName = "LastName"
        case firstName = "FirstName"
        case hasRegistered = "HasRegistered"
        case emailConfirmed = "EmailConfirmed"
        case fullName = "FullName"
        case dateOfBirth = "DateOfBirth"
        case occupationFK = "OccupationFK"
        case gender = "Gender"
        case countryFK = "CountryFK"
        case email = "Email"
        case address = "Address"
        case stateFK = "StateFK"
        case phoneNumber
        case isStudentRole = "IsStudentRole"
        case isMarkerRole = "IsMarkerRole"
        case isAdminRole = "IsAdminRole"
        case isLeadMarkerRole = "IsLeadMarkerRole"
        case userName = "UserName"
        case isAllowNotificationsViaPopUPS = "IsAllowNotificationsViaPopUps"
        case isAllowNotificationsViaEmail = "IsAllowNotificationsViaEmail"
        case isAllowNotificationsViaSMS = "IsAllowNotificationsViaSMS"
        case isAllowNotificationsForRating = "IsAllowNotificationsForRating"
        case isAllowNotificationsForNewsAndAnnoucements = "IsAllowNotificationsForNewsAndAnnoucements"
        case isAllowNotificationsForNewsletter = "IsAllowNotificationsForNewsletter"
        case isAllowNotificationsForMonthlyAccountStatement = "IsAllowNotificationsForMonthlyAccountStatement"
        case location = "Location"
        case displayName = "DisplayName"
        case countryCode = "CountryCode"
    }
}

struct RegisterResponse: Codable {
    let email, password, confirmPassword, roleName: String
    let firstName, lastName, occupationFK, gender: String?
    let address, phoneNumber, dateOfBirth: String?

    enum CodingKeys: String, CodingKey {
        case email = "Email"
        case password = "Password"
        case confirmPassword = "ConfirmPassword"
        case roleName = "RoleName"
        case firstName = "FirstName"
        case lastName = "LastName"
        case occupationFK = "OccupationFK"
        case gender = "Gender"
        case address = "Address"
        case phoneNumber = "PhoneNumber"
        case dateOfBirth = "DateOfBirth"
    }
}
