//
//  SignupApiClient.swift
//  Prepmewell
//
//  Created by ari on 8/1/21.
//

import Foundation
import Alamofire

class SignupApiClient {
    enum HttpMethodType: String {
        case get, post, patch, delete, put
    }
    
    func execute <DataModel: Decodable> (requestType: HttpMethodType = .get, url: String, params: [String: Any] = [:], headers: HTTPHeaders = [], encoding: ParameterEncoding = JSONEncoding.default, success: @escaping (DataModel) -> (), failure: @escaping (String) -> ()) {
    
        let convertedHttpMethod = httpMethodConversion(httpMethod: requestType)
        AF.request(url, method: convertedHttpMethod, parameters: params, encoding:
                    encoding, headers: headers).responseData { response in
                        do {
                            if let error = response.error {
                                if response.value != nil {
                                    let data = try JSONDecoder().decode(ErrorMessage.self, from: response.value!)
                                    failure(data.getMessage())
                                }
                                else {
                                    failure(error.localizedDescription)
                                }
                                return
                            }
                            guard let result = response.value else {
                                print("URLSession dataTask error:", response.error ?? "nil")
                                return
                            }
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
