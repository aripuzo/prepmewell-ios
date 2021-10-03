//
//  DefaultsKeys.swift
//  Prepmewell
//
//  Created by ari on 8/1/21.
//

import SwiftyUserDefaults

extension DefaultsKeys {
    var userData: DefaultsKey<User?> { .init("userData") }
    var token: DefaultsKey<String?> { .init("token") }
    var isLoggedIn: DefaultsKey<Bool> { .init("isLoggedIn", defaultValue: false) }
    var isOnboarded: DefaultsKey<Bool> { .init("isOnboarded", defaultValue: false) }
}
