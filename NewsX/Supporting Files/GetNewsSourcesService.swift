//
//  GetNewsSourcesService.swift
//  NewsX
//
//  Created by Push_Parn on 03/05/19.
//  Copyright © 2019 abes. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class GetNewsSourcesService {
    static func getSources(forUrl targetUrl: String, parameters: [String:Any],key: String, completionHandler: @escaping ([NewsSourceModel],Bool,Error?)->()) {
        
        var Results:[NewsSourceModel] = []
        print(parameters)
        Alamofire.request(targetUrl, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: nil).responseJSON {
            (responseObject) in
            if responseObject.result.isFailure , let error = responseObject.result.error {
                completionHandler([],false,error)
            }
            else if responseObject.result.isSuccess ,let responseFromServer = responseObject.result.value {
                
                let jsonData = JSON(responseFromServer)
               
                for _source in jsonData[key].arrayValue{
                    let source = NewsSourceModel(source: _source)
                    Results.append(source)
                }
                
                completionHandler(Results,true,nil)
                
            }
            else {
                completionHandler([],false,NSError(domain: "CustomErrorDomain", code: 100, userInfo: [NSLocalizedDescriptionKey : "Unable to get the response"]))
            }
            
            
        }
    }
}
