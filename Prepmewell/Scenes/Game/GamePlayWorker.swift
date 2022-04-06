//
//  GamePlayWorker.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 02/04/2022.
//

import Foundation

protocol GamePlayProtocol {
    func nextQuestion(gameResultFK: Int, questionGroupFK: Int, success: @escaping (DataResponse<GameQuestion>) -> (), failure: @escaping (String) -> ())
    func answerQuestion(gameResultFK: Int, gameQuestionFK: Int, answer: String, success: @escaping (ListResponse<GameAnswer>) -> (), failure: @escaping (String) -> ())
    func endGame(gameResultFK: Int, success: @escaping (StringResponse) -> (), failure: @escaping (String) -> ())
}

class GamePlayWorker: GamePlayProtocol {
    var networkClient: PrepmewellApiClient?

    func endGame(gameResultFK: Int, success: @escaping (StringResponse) -> (), failure: @escaping (String) -> ()) {
        networkClient?.execute(requestType: .post, url: "\(Constants.URL)api/Games/CompleteTest?MockTestResultFK=\(gameResultFK)", params: [:]) {(feedback: StringResponse) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func answerQuestion(gameResultFK: Int, gameQuestionFK: Int, answer: String, success: @escaping (ListResponse<GameAnswer>) -> (), failure: @escaping (String) -> ()) {
        networkClient?.execute(requestType: .post, url: "\(Constants.URL)api/Games/ProcessQuestion?MockTestResultFK=\(gameResultFK)&MockTestQuestionFK=\(gameQuestionFK)&answer=\(answer.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? answer)", params: [:]) {(feedback: ListResponse<GameAnswer>) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func nextQuestion(gameResultFK: Int, questionGroupFK: Int, success: @escaping (DataResponse<GameQuestion>) -> (), failure: @escaping (String) -> ()) {
        networkClient?.execute(requestType: .get, url: "\(Constants.URL)api/Games/NextQuestion?MockTestResultFK=\(gameResultFK)&QuestionGroupFK=\(questionGroupFK)", params: [:]) {(feedback: DataResponse<GameQuestion>) in
            success(feedback)
        } failure: { (error) in
            failure(error)
        }
    }
}
