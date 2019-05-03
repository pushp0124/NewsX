//
//  NewsTableViewCell.swift
//  NewsX
//
//  Created by Push_Parn on 03/05/19.
//  Copyright © 2019 abes. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImageView: UIImageView!
    
    @IBOutlet weak var newsPostedTimeLabel: UILabel!
    @IBOutlet weak var newsTitleLabel: UILabel!
    
    @IBOutlet weak var newsSourceLabel: UILabel!
    
    private func setUpCellUI() {
        
    }
    func setUpCell(news: NewsModel) {
        newsTitleLabel.text = news.newsTitle
        newsSourceLabel.text = news.source.sourceName
       let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:SSZ"
    
        if let date = dateFormatter.date(from: news.publishedTime)  {
            
             newsPostedTimeLabel.text = date.getElapsedInterval() + " ago"
        }

        let imageUrl = news.newsImageUrl.replacingOccurrences(of: "http://", with: "https://")
        newsImageView.loadImageUsingURLString(imageUrl, placeholderPicName: "Background")
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
