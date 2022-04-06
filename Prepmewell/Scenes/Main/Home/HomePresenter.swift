//
//  HomePresenter.swift
//  Prepmewell
//
//  Created by ari on 8/17/21.
//

import Foundation

protocol HomePresentationLogic {
    func displayUser(user: User)
    func displayDashboard(dashboard: Dashboard)
    func displayInterest(interests: ListResponse<Interest>)
    func displayError(alert: String)
    func logout()
}

class HomePresenter: HomePresentationLogic {
    
    var homeView: HomeDisplayLogic?

    func displayUser(user: User) {
        homeView?.displayUser(user: user)
    }
    
    func displayDashboard(dashboard: Dashboard) {
        homeView?.displayDashboard(dashboard: dashboard)
    }
    
    func displayError(alert: String) {
        homeView?.displayError(prompt: alert)
    }
    
    func displayInterest(interests: ListResponse<Interest>) {
        homeView?.displayInterest(interests: interests)
    }
    
    func logout() {
        homeView?.logout()
    }
    
}
