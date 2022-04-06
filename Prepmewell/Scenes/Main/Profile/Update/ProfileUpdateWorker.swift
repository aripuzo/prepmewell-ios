//
//  ProfileUpdateWorker.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 11/02/2022.
//

import Foundation
import Alamofire

protocol ProfileUpdateProtocol {
    func updateUser(data: UserUpdate, success: @escaping (DataResponse<User>) -> (), failure: @escaping (String) -> ())
    func getCountries(success: @escaping (ListResponse<Country>) -> (), failure: @escaping (String) -> ())
}

class ProfileUpdateWorker: ProfileUpdateProtocol {
    var networkClient: PrepmewellApiClient?

    func updateUser(data: UserUpdate, success: @escaping (DataResponse<User>) -> (), failure: @escaping (String) -> ()) {
        
        networkClient?.execute(requestType: .post, url: "\(Constants.URL)api/Account/UpdateProfile", params: ["Email": data.email, "DateOfBirth": data.dateOfBirth, "PhoneNumber": data.phoneNumber, "Location": data.location, "FirstName": data.firstName, "LastName": data.lastName, "Gender": data.gender]) {(feedback: DataResponse<User>) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func getCountries(success: @escaping (ListResponse<Country>) -> (), failure: @escaping (String) -> ()) {
        networkClient?.execute(requestType: .get, url: "\(Constants.URL)api/Countries/All", params: [:]) {(feedback: ListResponse<Country>) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
}
