//
//  HomeInteractor.swift
//  Prepmewell
//
//  Created by ari on 8/17/21.
//

import Foundation

protocol HomeBusinessLogic {
    func getUser()
    func getDashboard()
}

class HomeInteractor: HomeBusinessLogic {
    var presenter: HomePresentationLogic?
    var worker: HomeProtocol?

    func getUser() {
        worker?.getUser(success: { (feedback) in
            self.presenter?.displayUser(user: feedback)
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
    func getDashboard() {
        worker?.getDashboard(success: { (feedback) in
            self.presenter?.displayDashboard(dashboard: feedback.dashboard)
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
}
