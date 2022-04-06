//
//  GamePresenter.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 30/03/2022.
//

import Foundation

protocol GamePresentationLogic {
    func displayGames(games: ListResponse<Game>)
    func displayQuestionGroup(response: ListResponse<GameQuestionGroup>)
    func startGameResponse(response: ListResponse<TestResult>)
    func displayError(alert: String)
}

class GamePresenter: GamePresentationLogic {
    
    var view: GameDisplayLogic?

    func displayGames(games: ListResponse<Game>) {
        view?.displayGames(gamesResponse: games)
    }
    
    func displayError(alert: String) {
        view?.displayError(alert: alert)
    }
    
    func displayQuestionGroup(response: ListResponse<GameQuestionGroup>) {
        view?.displayQuestionGroup(response: response)
    }
    
    func startGameResponse(response: ListResponse<TestResult>) {
        view?.startGameResponse(response: response)
    }
    
}
