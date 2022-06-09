//
//  PlanInteractor.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 01/06/2022.
//

import Foundation

protocol PlanBusinessLogic {
    func getPlans()
    func getUserPlans()
    func updateUserPlan(data: UserPlanUpdate)
}

class PlanInteractor: PlanBusinessLogic {
    var presenter: PlanPresentationLogic?
    var worker: PlanProtocol?

    func getPlans() {
        worker?.getPlans(success: { (feedback) in
            self.presenter?.displayPlans(plans: feedback)
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
    func getUserPlans() {
        worker?.getUserPlans(success: { (feedback) in
            self.presenter?.displayUserPlans(plans: feedback)
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
    func updateUserPlan(data: UserPlanUpdate) {
        worker?.updateUserPlan(data: data, success: { (feedback) in
            self.presenter?.displayUserPlan(plan: feedback)
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
}
