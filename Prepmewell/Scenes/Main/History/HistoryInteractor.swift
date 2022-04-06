//
//  HistoryInteractor.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 11/02/2022.
//

import Foundation

protocol HistoryBusinessLogic {
    func getHistory(page: Int)
}

class HistoryInteractor: HistoryBusinessLogic {
    var presenter: HistoryPresentationLogic?
    var worker: HistoryProtocol?

    func getHistory(page: Int) {
        worker?.getHistory(page: page, success: { (feedback) in
            self.presenter?.displayHistory(history: feedback)
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
}
