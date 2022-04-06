//
//  ProfileUpdateInteractor.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 11/02/2022.
//

import Foundation

protocol ProfileUpdateBusinessLogic {
    func updateUser(data: UserUpdate)
    func getCountries()
}

class ProfileUpdateInteractor: ProfileUpdateBusinessLogic {
    var presenter: ProfileUpdatePresentationLogic?
    var worker: ProfileUpdateProtocol?

    func updateUser(data: UserUpdate) {
        worker?.updateUser(data: data, success: { (feedback) in
            self.presenter?.displayUpdateResult(result: feedback)
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
    func getCountries() {
        worker?.getCountries(success: { (feedback) in
            self.presenter?.displayCountries(countries: feedback)
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
}
