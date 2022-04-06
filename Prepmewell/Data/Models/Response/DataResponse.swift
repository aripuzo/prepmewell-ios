//
//  DataResponse.swift
//  Prepmewell
//
//  Created by ari on 8/1/21.
//

import Foundation

struct DataResponse<T: Decodable>: Decodable {
    let response: T?
}
