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
        
        let convertedHttpMethod = httpMethodConversion(httpMethod: requestType)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Defaults[\.token] ?? "")",
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
    
    func execute3 <DataModel: Decodable> (requestType: HttpMethodType = .post, url: String, json: String, success: @escaping (DataModel) -> (), failure: @escaping (String) -> ()) {
        
//        let url = URL(string: urlString)!
//        var request = URLRequest(url: url)
        
//        request.httpMethod = HTTPMethod.post.rawValue
//        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        let jsonData = json.data(using: .utf8, allowLossyConversion: false)!
//        request.httpBody = jsonData
        
        let convertedHttpMethod = httpMethodConversion(httpMethod: requestType)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Defaults[\.token]!)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        AF.upload(jsonData, to: url, headers: headers).responseData { response in
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
    
    func upload<DataModel: Decodable>(file: Data, fileName: String, fileType: String, to url: String, params: [String: Any], progress: @escaping (Double) -> (), success: @escaping (DataModel) -> (), failure: @escaping (String) -> ()) {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Defaults[\.token]!)",
            "Accept": "application/json",
            "Content-type": "multipart/form-data"
        ]
        
        AF.upload(multipartFormData: { multiPart in
            for (key, value) in params {
                if let temp = value as? String {
                    multiPart.append(temp.data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Int {
                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key + "[]"
                        if let string = element as? String {
                            multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
            }
            multiPart.append(file, withName: "file", fileName: fileName, mimeType: fileType)
        }, to: url, headers: headers)
            .uploadProgress(queue: .main, closure: { prog in
                //Current upload progress of file
                progress(prog.fractionCompleted)
            })
            .responseData(completionHandler: { response in
                print("--------------------------------------------------------------")
                print(response)
                if let error = response.error {
                    failure(error.localizedDescription)
                    return
                }
                guard let result = response.value else {
                    print("URLSession dataTask error:", response.error ?? "nil")
                    return
                }
                do {
                    if response.response!.statusCode >= 200 && response.response!.statusCode <= 300 {
                        print(result)
                        let data = try JSONDecoder().decode(DataModel.self, from: result as! Data)
                        success(data)
                    }
                    else {
                        let data = try JSONDecoder().decode(ErrorMessage.self, from: result as! Data)
                        failure(data.getMessage())
                    }
                    return
                } catch {
                    print("JSONSerialization error:", error)
                }
            })
    }
    
    // This function converts httpMethodType enum (business logic) to Alamofire httpmethod
    private func httpMethodConversion(httpMethod: HttpMethodType) -> HTTPMethod {
        let requestTypeRawValue = httpMethod.rawValue
        let convertedHttpMethod = HTTPMethod(rawValue: requestTypeRawValue)
        return convertedHttpMethod
    }
}
