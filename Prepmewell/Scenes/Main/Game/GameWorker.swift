//
//  GameWorker.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 30/03/2022.
//

import Foundation

protocol GameProtocol {
    func getGames(success: @escaping (ListResponse<Game>) -> (), failure: @escaping (String) -> ())
    func startGame(mockTestFK: Int, success: @escaping (ListResponse<TestResult>) -> (), failure: @escaping (String) -> ())
    func getQuestionGroup(mockTestFK: Int, success: @escaping (ListResponse<GameQuestionGroup>) -> (), failure: @escaping (String) -> ())
}

class GameWorker: GameProtocol {
    var networkClient: PrepmewellApiClient?

    func getQuestionGroup(mockTestFK: Int, success: @escaping (ListResponse<GameQuestionGroup>) -> (), failure: @escaping (String) -> ()) {
        networkClient?.execute(requestType: .get, url: "\(Constants.URL)api/Games/QuestionGroup", params: ["MockTestFK" : mockTestFK]) {(feedback: ListResponse<GameQuestionGroup>) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func startGame(mockTestFK: Int, success: @escaping (ListResponse<TestResult>) -> (), failure: @escaping (String) -> ()) {
        networkClient?.execute(requestType: .post, url: "\(Constants.URL)api/Games/StartTest?MockTestFK=\(mockTestFK)", params: [:]) {(feedback: ListResponse<TestResult>) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func getGames(success: @escaping (ListResponse<Game>) -> (), failure: @escaping (String) -> ()) {
        networkClient?.execute(requestType: .get, url: "\(Constants.URL)api/Games/All", params: [:]) {(feedback: ListResponse<Game>) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
}
