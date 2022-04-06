//
//  GameInteractor.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 30/03/2022.
//

import Foundation

protocol GameBusinessLogic {
    func getGames()
    func startGame(mockTestFK: Int)
    func getQuestionGroup(mockTestFK: Int)
}

class GameInteractor: GameBusinessLogic {
    var presenter: GamePresentationLogic?
    var worker: GameProtocol?

    func getGames() {
        worker?.getGames(success: { (feedback) in
            self.presenter?.displayGames(games: feedback)
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
    func startGame(mockTestFK: Int) {
        worker?.startGame(mockTestFK: mockTestFK, success: { (feedback) in
            self.presenter?.startGameResponse(response: feedback)
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
    func getQuestionGroup(mockTestFK: Int) {
        worker?.getQuestionGroup(mockTestFK: mockTestFK, success: { (feedback) in
            self.presenter?.displayQuestionGroup(response: feedback)
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
}
