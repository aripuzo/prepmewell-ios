//
//  QuestionnairePresenter.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 19/03/2022.
//

import Foundation

protocol QuestionnairePresentationLogic {
    func displayStudies(studies: ListResponse<Study>)
    func displayCountries(countries: ListResponse<Country>)
    func displayStudyTimes(studyTimes: ListResponse<StudyTime>)
    func displayCareerPaths(careerPaths: ListResponse<CareerPath>)
    func displayRelocateLocations(relocateLocations: ListResponse<RelocateLocation>)
    func displayDegreeQualifications(degreeQualifications: ListResponse<DegreeQualification>)
    func displayInterestTypes(interestTypes: ListResponse<InterestType>)
    func displayUpdateInterestResponse(response: StringResponse)
    func displayError(alert: String)
}

class QuestionnairePresenter: QuestionnairePresentationLogic {
    
    var step2aView: Step2aDisplayLogic?
    var step2bView: Step2bDisplayLogic?
    var step2cView: Step2cDisplayLogic?
    var step3View: Step3DisplayLogic?
    var step4View: Step4DisplayLogic?

    func displayError(alert: String) {
        step2aView?.displayError(alert: alert)
        step3View?.displayError(alert: alert)
        step2cView?.displayError(alert: alert)
        step2bView?.displayError(alert: alert)
        step4View?.displayError(alert: alert)
    }
    
    func displayStudies(studies: ListResponse<Study>) {
        step2aView?.displayStudies(studies: studies)
    }
    
    func displayCountries(countries: ListResponse<Country>) {
        step2aView?.displayCountries(countries: countries)
        step2bView?.displayCountries(countries: countries)
    }
    
    func displayStudyTimes(studyTimes: ListResponse<StudyTime>) {
        step2aView?.displayStudyTimes(studyTimes: studyTimes)
    }
    
    func displayCareerPaths(careerPaths: ListResponse<CareerPath>) {
        step2bView?.displayCareerPaths(careerPaths: careerPaths)
    }
    
    func displayRelocateLocations(relocateLocations: ListResponse<RelocateLocation>) {
        step2cView?.displayRelocateLocations(relocateLocations: relocateLocations)
    }
    
    func displayDegreeQualifications(degreeQualifications: ListResponse<DegreeQualification>){
        step3View?.displayDegreeQualifications(degreeQualifications: degreeQualifications)
    }
    
    func displayInterestTypes(interestTypes: ListResponse<InterestType>) {
        
    }
    
    func displayUpdateInterestResponse(response: StringResponse) {
        step4View?.displayUpdateInterestResponse(response: response)
    }
    
}
