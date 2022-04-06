//
//  GamePlayInteractor.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 02/04/2022.
//

import Foundation

protocol GamePlayBusinessLogic {
    func nextQuestion(gameResultFK: Int, questionGroupFK: Int)
    func answerQuestion(gameResultFK: Int, gameQuestionFK: Int, answer: String)
    func endGame(gameResultFK: Int)
}

class GamePlayInteractor: GamePlayBusinessLogic {
    var presenter: GamePlayPresentationLogic?
    var worker: GamePlayProtocol?

    func endGame(gameResultFK: Int) {
        worker?.endGame(gameResultFK: gameResultFK, success: { (feedback) in
            self.presenter?.endGameResponse(response: feedback)
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
    func nextQuestion(gameResultFK: Int, questionGroupFK: Int) {
        worker?.nextQuestion(gameResultFK: gameResultFK, questionGroupFK: questionGroupFK, success: { (feedback) in
            self.presenter?.displayNextQuestion(response: feedback)
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
    func answerQuestion(gameResultFK: Int, gameQuestionFK: Int, answer: String) {
        worker?.answerQuestion(gameResultFK: gameResultFK, gameQuestionFK: gameQuestionFK, answer: answer, success: { (feedback) in
            self.presenter?.displayAnswerQuestion(response: feedback)
        }, failure: { (error) in
            self.presenter?.displayError(alert: error)
        })
    }
    
}
