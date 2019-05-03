//
//  NewsModel.swift
//  NewsX
//
//  Created by Push_Parn on 03/05/19.
//  Copyright © 2019 abes. All rights reserved.
//

import Foundation
import SwiftyJSON
class NewsModel {
    private(set) var newsTitle: String
    private(set) var newsDescription: String
    private(set) var newsUrl: String
    private(set) var newsImageUrl: String
    private(set) var publishedTime: String
    private(set) var newsContent: String
    private(set) var source: NewsSourceModel
    
    init(news: JSON) {
       newsTitle = news["title"].stringValue
       newsDescription = news[""].stringValue
       newsUrl = news["url"].stringValue
       newsImageUrl = news["urlToImage"].stringValue
       publishedTime = news["publishedAt"].stringValue
       newsContent = news["content"].stringValue
       source = NewsSourceModel(source: news["source"]) 
    }
    
    
}
