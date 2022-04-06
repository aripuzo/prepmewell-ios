//
//  TestResultInteractor.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 04/04/2022.
//

import Foundation

protocol TestResultBusinessLogic {
    func getTestResult(testResultFk: Int)
}

class TestResultInteractor: TestResultBusinessLogic {
    var presenter: TestResultPresentationLogic?
    var worker: TestResultProtocol?

    func getTestResult(testResultFk: Int) {
        worker?.getTestResult(testResultFk: testResultFk, success: { (feedback) in
            self.presenter?.displayTestResult(response: feedback)
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
}
