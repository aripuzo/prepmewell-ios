//
//  HistoryWorker.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 11/02/2022.
//

import Foundation
import Alamofire

protocol HistoryProtocol {
    func getHistory(page: Int, success: @escaping (ListResponse<TestResult>) -> (), failure: @escaping (String) -> ())
}

class HistoryWorker: HistoryProtocol {
    var networkClient: PrepmewellApiClient?

    func getHistory(page: Int, success: @escaping (ListResponse<TestResult>) -> (), failure: @escaping (String) -> ()) {
        networkClient?.execute(requestType: .get, url: "\(Constants.URL)api/Admin/StudentReports?ReportName=MockTestResult", params: ["Page" : page]) {(feedback: ListResponse<TestResult>) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
}
