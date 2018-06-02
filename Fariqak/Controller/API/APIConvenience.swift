//
//  API Convenience.swift
//  Fariqak
//
//  Created by Esslam Emad on 17/5/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import Foundation
import Moya
import PromiseKit
import ResponseDetective
import SwiftyJSON

class API {
    
    class func CallApi<T: TargetType>(_ target: T) -> Promise<Data> {
        
        let configuration = URLSessionConfiguration.default
        ResponseDetective.enable(inConfiguration: configuration)
        let manager = Manager(configuration: configuration)
        
        let provider = MoyaProvider<T>(manager: manager)
        return Promise<Data> { seal in
            provider.request(target, completion: { (result) in
                switch result {
                    
                case let .success(moyaResponse):
                    guard let resp = try? JSON(data: moyaResponse.data) else {
                        let userInfo = [NSLocalizedDescriptionKey : "Generic1 Error"]
                        seal.reject(NSError(domain: "Casting to JSON", code: 1, userInfo: userInfo))
                        return
                    }
                    
                    guard moyaResponse.statusCode == 200 else {
                        seal.reject(NSError(domain: "\(moyaResponse.statusCode)", code: moyaResponse.statusCode, userInfo: ["response_message": "Response message from server"]))
                        return
                    }
                    // http status code is now 200 from here on
                    
                    guard resp["success"].stringValue == "success" || resp["status"].stringValue == "OK" else {
                        
                        let userInfo = [NSLocalizedDescriptionKey : resp["message"].string ?? "Generic Error"]
                        seal.reject(NSError(domain: "Checking for error codes", code: 1, userInfo: userInfo))
                        return
                        
                        
                    }
                    do {
                        let jsonData = try resp["result"].rawData(options: .prettyPrinted)
                        seal.fulfill(jsonData)
                    }
                    catch {
                        let userInfo = [NSLocalizedDescriptionKey : "Couldn't cast JSON to data"]
                        seal.reject(NSError(domain: "Casting JSON to data", code: 1, userInfo: userInfo))
                    }
                case let .failure(error):
                    seal.reject(error)
                }
            })
        }
    }
}
