//
//  UserUpdate.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 11/02/2022.
//

import Foundation

struct UserUpdate: Codable {
    var id: Int
    var lastName, firstName: String?
    var dateOfBirth : String?
    var gender: String
    var email: String
    var phoneNumber: String
    var userName: String
    var location: String
    

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case lastName = "LastName"
        case firstName = "FirstName"
        case dateOfBirth = "DateOfBirth"
        case gender = "Gender"
        case email = "Email"
        case phoneNumber = "PhoneNumber"
        case userName = "UserName"
        case location = "Location"
    }
}
