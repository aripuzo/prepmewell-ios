//
//  TestResultPresenter.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 04/04/2022.
//

import Foundation

protocol TestResultPresentationLogic {
    func displayTestResult(response: DataResponse<TestResult>)
    func displayError(alert: String)
}

class TestResultPresenter: TestResultPresentationLogic {
    
    var view: TestResultDisplayLogic?
    
    func displayTestResult(response: DataResponse<TestResult>) {
        view?.displayTestResult(response: response)
    }

    func displayError(alert: String) {
        view?.displayError(alert: alert)
    }
    
}
