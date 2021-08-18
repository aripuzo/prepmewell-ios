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
    
    func execute <DataModel: Decodable> (requestType: HttpMethodType = .get, url: String, params: [String: String] = [:], success: @escaping (DataModel) -> (), failure: @escaping (String) -> ()) {
       let convertedHttpMethod = httpMethodConversion(httpMethod: requestType)
       AF.request(url, method: convertedHttpMethod, parameters: params, encoding:
                   JSONEncoding.default).responseDecodable(of: DataModel.self) { response in
                      if let error = response.error {
                         failure(error.localizedDescription)
                         return
                      }
                      if let result = response.value {
                         success(result)
                         return
                      }
                   }
    }
   
   func execute2 <DataModel: Decodable> (requestType: HttpMethodType = .get, url: String, params: [String: String] = [:], success: @escaping (DataModel) -> (), failure: @escaping (String) -> ()) {
      let convertedHttpMethod = httpMethodConversion(httpMethod: requestType)
      AF.request(url, method: convertedHttpMethod, parameters: params, encoding:
                  JSONEncoding.default).responseData { response in
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
                            let data = try JSONDecoder().decode(DataModel.self, from: result)
                            success(data)
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
