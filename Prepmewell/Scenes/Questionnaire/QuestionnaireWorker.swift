//
//  QuestionnaireWorker.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 19/03/2022.
//

import Foundation
import Alamofire

protocol QuestionnaireProtocol {
    func getStudies(success: @escaping (ListResponse<Study>) -> (), failure: @escaping (String) -> ())
    func getCountries(success: @escaping (ListResponse<Country>) -> (), failure: @escaping (String) -> ())
    func getStudyTimes(success: @escaping (ListResponse<StudyTime>) -> (), failure: @escaping (String) -> ())
    func getCareerPaths(success: @escaping (ListResponse<CareerPath>) -> (), failure: @escaping (String) -> ())
    func getRelocateLocations(success: @escaping (ListResponse<RelocateLocation>) -> (), failure: @escaping (String) -> ())
    func getDegreeQualifications(success: @escaping (ListResponse<DegreeQualification>) -> (), failure: @escaping (String) -> ())
    func getInterestTypes(success: @escaping (ListResponse<InterestType>) -> (), failure: @escaping (String) -> ())
    func updateInterest(data: InterestUpdate, success: @escaping (StringResponse) -> (), failure: @escaping (String) -> ())
}

class QuestionnaireWorker: QuestionnaireProtocol {
    var networkClient: PrepmewellApiClient?

    func getStudies(success: @escaping (ListResponse<Study>) -> (), failure: @escaping (String) -> ()) {
        networkClient?.execute(requestType: .get, url: "\(Constants.URL)api/Study/All", params: [:]) {(feedback: ListResponse<Study>) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func getCountries(success: @escaping (ListResponse<Country>) -> (), failure: @escaping (String) -> ()) {
        networkClient?.execute(requestType: .get, url: "\(Constants.URL)api/Countries/All", params: [:]) {(feedback: ListResponse<Country>) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func getStudyTimes(success: @escaping (ListResponse<StudyTime>) -> (), failure: @escaping (String) -> ()) {
        networkClient?.execute(requestType: .get, url: "\(Constants.URL)api/StudyTime/All", params: [:]) {(feedback: ListResponse<StudyTime>) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func getCareerPaths(success: @escaping (ListResponse<CareerPath>) -> (), failure: @escaping (String) -> ()) {
        networkClient?.execute(requestType: .get, url: "\(Constants.URL)api/CareerPath/All", params: [:]) {(feedback: ListResponse<CareerPath>) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func getRelocateLocations(success: @escaping (ListResponse<RelocateLocation>) -> (), failure: @escaping (String) -> ()) {
        networkClient?.execute(requestType: .get, url: "\(Constants.URL)api/RelocateLocation/All", params: [:]) {(feedback: ListResponse<RelocateLocation>) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func getDegreeQualifications(success: @escaping (ListResponse<DegreeQualification>) -> (), failure: @escaping (String) -> ()) {
        networkClient?.execute(requestType: .get, url: "\(Constants.URL)api/DegreeQualification/All", params: [:]) {(feedback: ListResponse<DegreeQualification>) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func getInterestTypes(success: @escaping (ListResponse<InterestType>) -> (), failure: @escaping (String) -> ()) {
        networkClient?.execute(requestType: .get, url: "\(Constants.URL)api/Interest/All", params: [:]) {(feedback: ListResponse<InterestType>) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func updateInterest(data: InterestUpdate, success: @escaping (StringResponse) -> (), failure: @escaping (String) -> ()) {
        
        let params = data.paramsFromJSON()
        if params != nil {
            networkClient?.execute(requestType: .post, url: "\(Constants.URL)api/StudentStudyInterest", params: params!) {(feedback: StringResponse) in
                success(feedback)
            } failure: { (error) in
                failure(error)
            }
        } else {
            failure("Invalid information provided")
        }
    }
}
