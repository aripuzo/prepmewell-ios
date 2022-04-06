//
//  TestResultWorker.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 04/04/2022.
//

import Foundation

protocol TestResultProtocol {
    func getTestResult(testResultFk: Int, success: @escaping (DataResponse<TestResult>) -> (), failure: @escaping (String) -> ())
}

class TestResultWorker: TestResultProtocol {
    var networkClient: PrepmewellApiClient?

    func getTestResult(testResultFk: Int, success: @escaping (DataResponse<TestResult>) -> (), failure: @escaping (String) -> ()) {
        networkClient?.execute(requestType: .get, url: "\(Constants.URL)api/MockTestResult/\(testResultFk)", params: [:]) {(feedback: DataResponse<TestResult>) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
}
