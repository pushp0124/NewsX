//
//  NewsSourceTableViewCell.swift
//  NewsX
//
//  Created by Push_Parn on 03/05/19.
//  Copyright © 2019 abes. All rights reserved.
//

import UIKit

class NewsSourceTableViewCell: UITableViewCell {

    @IBOutlet weak var sourceDescriptionLabel: UILabel!
    @IBOutlet weak var sourceNameLabel: UILabel!
    
    func setUp(newsSource: NewsSourceModel) {
        sourceNameLabel.text = newsSource.sourceName
        sourceDescriptionLabel.text = newsSource.description
    }
  
}
