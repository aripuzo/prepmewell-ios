//
//  HomeWorker.swift
//  Prepmewell
//
//  Created by ari on 8/17/21.
//

import Foundation
import Alamofire

protocol HomeProtocol {
    func getUser(success: @escaping (User) -> (), failure: @escaping (String) -> ())
    func getDashboard(success: @escaping (DashboardResponse) -> (), failure: @escaping (String) -> ())
}

class HomeWorker: HomeProtocol {
    var networkClient: PrepmewellApiClient?

    func getUser(success: @escaping (User) -> (), failure: @escaping (String) -> ()) {
        networkClient?.execute(requestType: .get, url: "\(Constants.URL)api/Account/UserInfo", params: [:]) {(feedback: User) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func getDashboard(success: @escaping (DashboardResponse) -> (), failure: @escaping (String) -> ()) {
        networkClient?.execute(requestType: .get, url: "\(Constants.URL)api/Dashboard/All", params: [:]) {(feedback: DashboardResponse) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
}
