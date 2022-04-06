//
//  Alamofire+Extension.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 24/03/2022.
//

import Alamofire

extension Alamofire.Manager {
    public class func request(
        method: Alamofire.Method,
        _ URLString: URLStringConvertible,
          bodyObject: EVObject)
        -> Request
    {
        return Manager.sharedInstance.request(
            method,
            URLString,
            parameters: [:],
            encoding: .Custom({ (convertible, params) in
                let mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
                mutableRequest.HTTPBody = bodyObject.toJsonString().dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                return (mutableRequest, nil)
            })
        )
    }
}
