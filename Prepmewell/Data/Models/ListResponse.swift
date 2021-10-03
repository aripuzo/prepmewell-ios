//
//  ListResponse.swift
//  Prepmewell
//
//  Created by ari on 8/18/21.
//

import Foundation

struct ListResponse<T: Decodable>: Decodable {
    let response: [T]
    let pagination: Pagination?
    
    enum CodingKeys: String, CodingKey {
        case response
        case pagination
    }
}

struct Pagination: Codable {
    let currentPage: Int
    let totalPages: Int
    let pageSize: Int
    let totalRecords: Int
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "CurrentPage"
        case totalPages = "TotalPages"
        case pageSize = "PageSize"
        case totalRecords = "TotalRecords"
    }
}
