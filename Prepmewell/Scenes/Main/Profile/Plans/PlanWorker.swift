//
//  PlanWorker.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 01/06/2022.
//

import Foundation

protocol PlanProtocol {
    func getPlans(success: @escaping (ListResponse<Plan>) -> (), failure: @escaping (String) -> ())
    func getUserPlans(success: @escaping (ListResponse<UserPlan>) -> (), failure: @escaping (String) -> ())
    func updateUserPlan(data: UserPlanUpdate, success: @escaping (DataResponse<UserPlan>) -> (), failure: @escaping (String) -> ())
}

class PlanWorker: PlanProtocol {
    var networkClient: PrepmewellApiClient?
    
    func getPlans(success: @escaping (ListResponse<Plan>) -> (), failure: @escaping (String) -> ()) {
        networkClient?.execute(requestType: .get, url: "\(Constants.URL)api/Plan/All", params: [:]) {(feedback: ListResponse<Plan>) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func getUserPlans(success: @escaping (ListResponse<UserPlan>) -> (), failure: @escaping (String) -> ()) {
        networkClient?.execute(requestType: .get, url: "\(Constants.URL)api/UserPlan/All", params: [:]) {(feedback: ListResponse<UserPlan>) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func updateUserPlan(data: UserPlanUpdate, success: @escaping (DataResponse<UserPlan>) -> (), failure: @escaping (String) -> ()) {
        
        let params = data.paramsFromJSON()
        if params != nil {
            networkClient?.execute(requestType: .post, url: "\(Constants.URL)api/UserPlan", params: params!) {(feedback: DataResponse<UserPlan>) in
                success(feedback)
            } failure: { (error) in
                failure(error)
            }
        } else {
            failure("Invalid information provided")
        }
    }
}
