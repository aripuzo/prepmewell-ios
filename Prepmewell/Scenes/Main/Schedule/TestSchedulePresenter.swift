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
    func displayError(alert: String)
}

class TestSchedulePresenter: TestSchedulePresentationLogic {
    
    var view: TestScheduleDisplayLogic?

    func displayError(alert: String) {
        view?.displayError(alert: alert)
    }
    
    func displaySchedules(schedules: DataResponse<ScheduleDataResponse>) {
        view?.displaySchedules(schedules: schedules)
    }
    
    func displayScheduleTestResponse(response: DataResponse<Schedule>) {
        view?.displayScheduleTestResponse(response: response)
    }
    
}
