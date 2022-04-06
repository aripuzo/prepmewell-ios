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
    func getInterest(studentFk: Int)
}

class HomeInteractor: HomeBusinessLogic {
    var presenter: HomePresentationLogic?
    var worker: HomeProtocol?

    func getUser() {
        worker?.getUser(success: { (feedback) in
            self.presenter?.displayUser(user: feedback)
        }, failure: { (error) in
            if error.contains("Authorization has been denied for this request") {
                self.presenter?.logout()
            }
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
    
    func getInterest(studentFk: Int) {
        worker?.getInterest(studentFk: studentFk, success: { (feedback) in
            self.presenter?.displayInterest(interests: feedback)
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
}
