//
//  PrepmewellApiClient.swift
//  Prepmewell
//
//  Created by ari on 8/16/21.
//

import Foundation
import Alamofire
import SwiftyUserDefaults

class PrepmewellApiClient {
    enum HttpMethodType: String {
        case get, post, patch, delete, put
    }
    
    func execute <DataModel: Decodable> (requestType: HttpMethodType = .get, url: String, params: [String: Any] = [:], success: @escaping (DataModel) -> (), failure: @escaping (String) -> ()) {
        
        print(Defaults[\.token]!)
        
        let convertedHttpMethod = httpMethodConversion(httpMethod: requestType)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Defaults[\.token]!)",
            "Accept": "application/json"
        ]
        AF.request(url, method: convertedHttpMethod, parameters: params, headers: headers).responseData { response in
            if let error = response.error {
                failure(error.localizedDescription)
                return
            }
            guard let result = response.value else {
                print("URLSession dataTask error:", response.error ?? "nil")
                return
            }
            do {
                print(String(decoding: result, as: UTF8.self))
                if response.response!.statusCode >= 200 && response.response!.statusCode <= 300 {
                    let data = try JSONDecoder().decode(DataModel.self, from: result)
                    success(data)
                }
                else {
                    let data = try JSONDecoder().decode(ErrorMessage.self, from: result)
                    failure(data.getMessage())
                }
                return
            } catch {
                print("JSONSerialization error:", error)
            }
        }
    }
    
    func execute2 <DataModel: Decodable> (requestType: HttpMethodType = .get, url: String, params: [String: Any] = [:], success: @escaping (DataModel) -> (), failure: @escaping (String) -> ()) {
        
        let convertedHttpMethod = httpMethodConversion(httpMethod: requestType)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Defaults[\.token]!)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        AF.request(url, method: convertedHttpMethod, parameters: params, encoding:
        JSONEncoding.default, headers: headers).responseData { response in
            if let error = response.error {
                failure(error.localizedDescription)
                return
            }
            guard let result = response.value else {
                print("URLSession dataTask error:", response.error ?? "nil")
                return
            }
            do {
                print(String(decoding: result, as: UTF8.self))
                if response.response!.statusCode >= 200 && response.response!.statusCode <= 300 {
                    let data = try JSONDecoder().decode(DataModel.self, from: result)
                    success(data)
                }
                else {
                    let data = try JSONDecoder().decode(ErrorMessage.self, from: result)
                    failure(data.getMessage())
                }
                return
            } catch {
                print("JSONSerialization error:", error)
            }
        }
    }
    
    // This function converts httpMethodType enum (business logic) to Alamofire httpmethod
    private func httpMethodConversion(httpMethod: HttpMethodType) -> HTTPMethod {
        let requestTypeRawValue = httpMethod.rawValue
        let convertedHttpMethod = HTTPMethod(rawValue: requestTypeRawValue)
        return convertedHttpMethod
    }
}
