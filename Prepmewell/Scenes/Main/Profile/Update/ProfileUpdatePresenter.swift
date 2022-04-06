//
//  ProfileUpdatePresenter.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 11/02/2022.
//

import Foundation

protocol ProfileUpdatePresentationLogic {
    func displayUpdateResult(result: DataResponse<User>)
    func displayCountries(countries: ListResponse<Country>)
    func displayError(alert: String)
}

class ProfileUpdatePresenter: ProfileUpdatePresentationLogic {
    func displayError(alert: String) {
        homeView?.displayError(alert: alert)
    }
    
    func displayUpdateResult(result: DataResponse<User>) {
        homeView?.displayUpdateResult(resut: result)
    }
    
    func displayCountries(countries: ListResponse<Country>) {
        homeView?.displayCountries(countries: countries)
    }
    
    
    var homeView: ProfileUpdateDisplayLogic?
    
}
