//
//  NewsSourceModel.swift
//  NewsX
//
//  Created by Push_Parn on 03/05/19.
//  Copyright © 2019 abes. All rights reserved.
//

import Foundation
import SwiftyJSON
class NewsSourceModel {
    private(set) var sourceId: String?
    private(set) var sourceName: String?
    private(set) var description: String?
    private(set) var sourceUrl: String?
    private(set) var language: String?
    private(set) var country: String?
    init(source: JSON) {
        sourceId = source["id"].string
        sourceName = source["name"].stringValue
        description = source["description"].string
        sourceUrl = source["sourceUrl"].string
        language = source["language"].string
        country = source["country"].string
    }
}
