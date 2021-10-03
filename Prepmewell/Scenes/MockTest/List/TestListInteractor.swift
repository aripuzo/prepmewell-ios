//
//  TestListInteractor.swift
//  Prepmewell
//
//  Created by ari on 8/18/21.
//

import Foundation

protocol TestListBusinessLogic {
    func getMockTests(testTypeFk: Int, mockTypeFK: Int?, pageNo: Int?)
    func startTest(mockTestFK: Int, writingTypeName: String?)
}

class TestListInteractor: TestListBusinessLogic {
    var presenter: TestListPresentationLogic?
    var worker: TestListProtocol?

    func getMockTests(testTypeFk: Int, mockTypeFK: Int?, pageNo: Int?) {
        worker?.getMockTests(testTypeFk: testTypeFk, mockTypeFK: mockTypeFK, pageNo: pageNo, success: { (feedback) in
            self.presenter?.displayMockTests(mockTestResponse: feedback)
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
    func startTest(mockTestFK: Int, writingTypeName: String?) {
        worker?.startTest(mockTestFK: mockTestFK, writingTypeName: writingTypeName, success: { (feedback) in
            self.presenter?.startTestResponse(response: feedback)
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
}
