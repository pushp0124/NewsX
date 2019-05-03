//
//  GetTrendingNewsService.swift
//  NewsX
//
//  Created by Push_Parn on 03/05/19.
//  Copyright © 2019 abes. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class GetNewsService {
    static func getNews(forUrl targetUrl: String, parameters: [String:Any],key: String, completionHandler: @escaping ([NewsModel],Bool,Error?)->()) {

        var Results:[NewsModel] = []
        
        Alamofire.request(targetUrl, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: nil).responseJSON {
            (responseObject) in
            if responseObject.result.isFailure , let error = responseObject.result.error {
                completionHandler([],false,error)
            }
            else if responseObject.result.isSuccess ,let responseFromServer = responseObject.result.value {

                let jsonData = JSON(responseFromServer)
                //print(jsonData)
                for news in jsonData[key].arrayValue{
                   let news = NewsModel(news: news)
                  Results.append(news)
                }

                completionHandler(Results,true,nil)

            }
            else {
                completionHandler([],false,NSError(domain: "CustomErrorDomain", code: 100, userInfo: [NSLocalizedDescriptionKey : "Unable to get the response"]))
            }


        }
    }
}
