//
//  Constants.swift
//  Prepmewell
//
//  Created by ari on 8/1/21.
//

import Foundation

enum Constants {
    
    static let URL = "https://indigovisas.com/"//"http://beta.indigovisas.com/"
    static let INTEREST_TYPE_STUDY_ABROAD = 1
    static let INTEREST_TYPE_WORK_ABROAD = 2
    static let INTEREST_TYPE_RELOCATE_ABROAD = 3

    static let TEST_TYPE_LISTENING = 1
    static let TEST_TYPE_READING = 2
    static let TEST_TYPE_SPEAKING = 3
    static let TEST_TYPE_WRITING = 4
    static let TEST_TYPE_MARKER = 6

    static let WRITING_TYPE_WRITE = "Typed"
    static let WRITING_TYPE_UPLOAD = "uploaded"
}

enum ScreenID {
    static let MAIN = "MainTabViewController"
    static let AUTH = "AuthViewController"
    static let TEST_LIST = "TestListViewController"
    static let WRITING_TEST = "WritingTestViewController"
    static let READING_TEST = "ReadingTestViewController"
    static let LISTENING_TEST = "ListeningTestViewController"
    static let SPEAKING_TEST = "SpeakingTestViewController"
    static let GAME_PLAY = "GamePlayViewController"
    static let GAME_RESULT = "GameResultViewController"
    static let TIP = "TipViewController"
}
