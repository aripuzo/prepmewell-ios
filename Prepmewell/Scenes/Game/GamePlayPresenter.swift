//
//  GamePlayPresenter.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 02/04/2022.
//

import Foundation

protocol GamePlayPresentationLogic {
    func displayNextQuestion(response: DataResponse<GameQuestion>)
    func displayAnswerQuestion(response: ListResponse<GameAnswer>)
    func endGameResponse(response: StringResponse)
    func displayError(alert: String)
}

class GamePlayPresenter: GamePlayPresentationLogic {
    func displayNextQuestion(response: DataResponse<GameQuestion>) {
        view?.displayNextQuestion(response: response)
    }
    
    func displayAnswerQuestion(response: ListResponse<GameAnswer>) {
        view?.displayAnswerQuestion(response: response)
    }
    
    func endGameResponse(response: StringResponse) {
        view?.endGameResponse(response: response)
    }
    
    
    var view: GamePlayDisplayLogic?

    func displayError(alert: String) {
        view?.displayError(alert: alert)
    }
    
}
