//
//  PlanPresenter.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 01/06/2022.
//

import Foundation

protocol PlanPresentationLogic {
    func displayPlans(plans: ListResponse<Plan>)
    func displayUserPlans(plans: ListResponse<UserPlan>)
    func displayUserPlan(plan: DataResponse<UserPlan>)
    func displayError(alert: String)
}

class PlanPresenter: PlanPresentationLogic {
    
    var view: PlanDisplayLogic?

    func displayPlans(plans: ListResponse<Plan>) {
        view?.displayPlans(plansResponse: plans)
    }
    
    func displayUserPlans(plans: ListResponse<UserPlan>) {
        view?.displayUserPlans(plans: plans)
    }
    
    func displayError(alert: String) {
        view?.displayError(alert: alert)
    }
    
    func displayUserPlan(plan: DataResponse<UserPlan>) {
        view?.displayUserPlan(plan: plan)
    }
    
}
