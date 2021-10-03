//
//  TestListPresenter.swift
//  Prepmewell
//
//  Created by ari on 8/18/21.
//

import Foundation

protocol TestListPresentationLogic {
    func displayMockTests(mockTestResponse: ListResponse<MockTest>)
    func startTestResponse(response: StringResponse)
    func displayError(alert: String)
}

class TestListPresenter: TestListPresentationLogic {
    var view: TestListDisplayLogic?

    func displayMockTests(mockTestResponse: ListResponse<MockTest>) {
        view?.displayMockTests(mockTestResponse: mockTestResponse)
    }
    
    func startTestResponse(response: StringResponse) {
        view?.startTestResponse(response: response)
    }
    
    func displayError(alert: String) {
        view?.displayError(alert: alert)
    }
    
}
