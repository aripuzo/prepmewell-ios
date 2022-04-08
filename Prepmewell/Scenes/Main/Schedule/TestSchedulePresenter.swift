//
//  TestSchedulePresenter.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 06/04/2022.
//

import Foundation

protocol TestSchedulePresentationLogic {
    func displaySchedules(schedules: DataResponse<ScheduleDataResponse>)
    func displayScheduleTestResponse(response: DataResponse<Schedule>)
    func displayTestTypes(response: ListResponse<TestType>)
    func displayMockTests(response: ListResponse<MockTest>)
    func displayError(alert: String)
}

class TestSchedulePresenter: TestSchedulePresentationLogic {
    
    var view: TestScheduleDisplayLogic?
    var view2: NewScheduleDisplayLogic?

    func displayError(alert: String) {
        view?.displayError(alert: alert)
        view2?.displayError(alert: alert)
    }
    
    func displaySchedules(schedules: DataResponse<ScheduleDataResponse>) {
        view?.displaySchedules(schedules: schedules)
    }
    
    func displayScheduleTestResponse(response: DataResponse<Schedule>) {
        view2?.displayScheduleTestResponse(response: response)
    }
    
    func displayTestTypes(response: ListResponse<TestType>) {
        view2?.displayTestTypes(response: response)
    }
    
    func displayMockTests(response: ListResponse<MockTest>) {
        view2?.displayMockTests(response: response)
    }
    
}
