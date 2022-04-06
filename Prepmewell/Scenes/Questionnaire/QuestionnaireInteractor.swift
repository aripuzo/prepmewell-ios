//
//  QuestionnaireInteractor.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 19/03/2022.
//

import Foundation

protocol QuestionnaireBusinessLogic {
    func getStudies()
    func getCountries()
    func getStudyTimes()
    func getCareerPaths()
    func getRelocateLocations()
    func getDegreeQualifications()
    func getInterestTypes()
    func updateInterest(data: InterestUpdate)
}

class QuestionnaireInteractor: QuestionnaireBusinessLogic {
    var presenter: QuestionnairePresentationLogic?
    var worker: QuestionnaireProtocol?

    func getStudies() {
        worker?.getStudies(success: { (feedback) in
            self.presenter?.displayStudies(studies: feedback)
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
    
    func getStudyTimes() {
        worker?.getStudyTimes(success: { (feedback) in
            self.presenter?.displayStudyTimes(studyTimes: feedback)
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
    func getCareerPaths() {
        worker?.getCareerPaths(success: { (feedback) in
            self.presenter?.displayCareerPaths(careerPaths: feedback)
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
    func getRelocateLocations() {
        worker?.getRelocateLocations(success: { (feedback) in
            self.presenter?.displayRelocateLocations(relocateLocations: feedback)
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
    func getDegreeQualifications() {
        worker?.getDegreeQualifications(success: { (feedback) in
            self.presenter?.displayDegreeQualifications(degreeQualifications: feedback)
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
    func getInterestTypes() {
        worker?.getInterestTypes(success: { (feedback) in
            self.presenter?.displayInterestTypes(interestTypes: feedback)
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
    func updateInterest(data: InterestUpdate) {
        worker?.updateInterest(data: data, success: { (feedback) in
            self.presenter?.displayUpdateInterestResponse(response: feedback)
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
}
