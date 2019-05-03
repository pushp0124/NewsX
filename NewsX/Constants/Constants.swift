//
//  Constants.swift
//  NewsX
//
//  Created by Push_Parn on 03/05/19.
//  Copyright © 2019 abes. All rights reserved.
//

import Foundation
import UIKit
struct Identifiers {
    static let sharedInstance = Identifiers()
    private init() {
        
    }
    let NewsTableViewCellIdentifier = "newsTableCell"
    let TopHeadlinesTabStoryBoardIdentifier = "TopHeadlinesTab"
    let MiddleGapCellIdentifier = "middleGapCell"
    let ShowExternalWebsiteWebViewWindowIdentifier = "ShowExternalWebsiteWebViewStoryBoardIdentifier"
    
    let TopHeadlinesWindowIdentifier = "TopHeadlinesStoryBoardIdentifier"
    let SourceTableViewCellIdentifier = "sourceTableCell"
}
struct Colors {
    static let primaryColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

    static let pWhiteColorswift = UIColor.white
    static let pBlackColorswift = UIColor.black
    static let pToolBarColorswift = primaryColor
}
