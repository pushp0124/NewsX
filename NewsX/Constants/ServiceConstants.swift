//
//  ServiceConstants.swift
//  NewsX
//
//  Created by Push_Parn on 03/05/19.
//  Copyright © 2019 abes. All rights reserved.
//

import Foundation
struct ServiceUrl {
    private let baseUrl = "https://newsapi.org/v2"
    var getTopHeadlinesNews: String {
        get{
            return  baseUrl + "/top-headlines"
        }
    }
    var getEveryNews: String {
        get {
            return baseUrl + "/everything"
        }
    }
    var getNewsSouce: String {
        get {
            return baseUrl + "/sources"
        }
    }
    
    
    
    static let sharedInstance = ServiceUrl()
    private init() {
        
    }
}
