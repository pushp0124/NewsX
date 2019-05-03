//
//  NewsSourcesViewController.swift
//  NewsX
//
//  Created by Push_Parn on 03/05/19.
//  Copyright © 2019 abes. All rights reserved.
//

import UIKit

class NewsSourcesViewController: UIViewController {

    
    @IBOutlet weak var newsSourcesTableView: UITableView!
    
    var parentActivityIndicator: UIActivityIndicatorView?
    var newsSourcesTabledataSource =  [NewsSourceModel]()
    func setUp() {
        newsSourcesTableView.delegate = self
        newsSourcesTableView.dataSource = self
        self.navigationItem.title = "News Sources!"
    }
    var isLoading = false
    private func setUpUI() {
        
        
        let frameForParent = CGRect(x: self.view.center.x/2, y: CGFloat(60), width: self.newsSourcesTableView.bounds.width/2, height: CGFloat(44))
        
        
        parentActivityIndicator = ActivityIndicatorView.simpleActivityIndicatorView(frame: frameForParent, type: .gray, color: nil)
        newsSourcesTableView.addSubview(parentActivityIndicator!)
        
        
        newsSourcesTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.newsSourcesTableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 50.0, 0.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpUI()
        getTopHeadlinesApiFetching()
    }

    func getTopHeadlinesApiFetching() {
        isLoading = true
        
        let parameters: [String: Any] = ["apiKey":"9906493df5204cd8a095bffc30acb720","language":"en"]
        
        parentActivityIndicator?.startAnimating()
        GetNewsSourcesService.getSources(forUrl: ServiceUrl.sharedInstance.getNewsSouce, parameters: parameters, key: "sources", completionHandler: { (newsSources, isFinsihed, error) in
            
            if error != nil {
                print(error?.localizedDescription ?? "")
                let duration = 2.0
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration, execute: {
                    
                    self.parentActivityIndicator?.stopAnimating()
                    if error?._code == -1009 {
                        DropDownAlert.showMessage("Your Internet connection is lost!", withTextColor: Colors.pWhiteColorswift, backGroundColor: Colors.primaryColor, position: .bottom, duration: 3)
                    }  else {
                        DropDownAlert.showMessage("Something Unexpected Occurred!", withTextColor: Colors.pWhiteColorswift, backGroundColor: Colors.primaryColor, position: .bottom, duration: 3)
                    }
                })
                
            } else {
                DispatchQueue.global(qos: .userInitiated).async {
                    
                    for source in newsSources {
                        self.newsSourcesTabledataSource.append(source)
                    }
                    
                    DispatchQueue.main.async {
                        self.isLoading = false

                        self.parentActivityIndicator?.stopAnimating()
                       
                        self.newsSourcesTableView.reloadData()
                    }
                }
                
            }
            
        })
        
        
    }

}
extension NewsSourcesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((newsSourcesTabledataSource.count * 2) - 1)
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1000
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 1 {
            return 10
        }
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 1 {
            return tableView.dequeueReusableCell(withIdentifier: Identifiers.sharedInstance.MiddleGapCellIdentifier, for: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.sharedInstance.SourceTableViewCellIdentifier) as! NewsSourceTableViewCell
        cell.selectionStyle = .none
        cell.setUp(newsSource: newsSourcesTabledataSource[indexPath.row/2])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Identifiers.sharedInstance.TopHeadlinesTabStoryBoardIdentifier, bundle: nil)
        let newsVC = storyboard.instantiateViewController(withIdentifier: Identifiers.sharedInstance.TopHeadlinesWindowIdentifier) as! TopHeadlinesViewController
        newsVC.searchPlaceHolder = "Search News From The Source!"
        newsVC.newsSource = newsSourcesTabledataSource[indexPath.row/2]
        newsVC.useCase = 1
        self.navigationController?.pushViewController(newsVC, animated: true)
    }
    
}
