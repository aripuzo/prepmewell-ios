//
//  HistoryPresenter.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 11/02/2022.
//

import Foundation

protocol HistoryPresentationLogic {
    func displayHistory(history: ListResponse<TestResult>)
    func displayError(alert: String)
}

class HistoryPresenter: HistoryPresentationLogic {
    
    var homeView: HistoryDisplayLogic?

    func displayHistory(history: ListResponse<TestResult>) {
        homeView?.displayHistory(history: history)
    }
    
    func displayError(alert: String) {
        homeView?.displayError(prompt: alert)
    }
    
}
