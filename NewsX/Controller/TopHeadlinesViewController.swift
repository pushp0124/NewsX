//
//  ViewController.swift
//  NewsX
//
//  Created by Push_Parn on 03/05/19.
//  Copyright © 2019 abes. All rights reserved.
//

import UIKit
import SwiftyJSON
class TopHeadlinesViewController: UIViewController {
     var topHeadlinesTableDataSource = [NewsModel]()
     var pageNum = 1
    var childActivityIndicator: UIActivityIndicatorView?
    var parentActivityIndicator: UIActivityIndicatorView?
    var isLoading = false
    var moreItems = true
    var searchText: String?
    var searchPlaceHolder = "Search TopHeadlines!"
    var useCase = 0
    var newsSource : NewsSourceModel?
    @IBOutlet weak var trendingTableView: UITableView!
    @IBOutlet weak var topHeadlinesSearchBar: UISearchBar!
    
    @IBOutlet var noSearchContentFoundView: UIView!
    
    private func setUpUI() {
        let frameForChild = CGRect(x: CGFloat(0), y: CGFloat(0), width: trendingTableView.bounds.width, height: CGFloat(44))
        
        let frameForParent = CGRect(x: self.view.center.x/2, y: CGFloat(60), width: self.trendingTableView.bounds.width/2, height: CGFloat(44))
  
        childActivityIndicator = ActivityIndicatorView.simpleActivityIndicatorView(frame: frameForChild, type: .gray, color: nil)
        parentActivityIndicator = ActivityIndicatorView.simpleActivityIndicatorView(frame: frameForParent, type: .gray, color: nil)
        trendingTableView.addSubview(parentActivityIndicator!)
        trendingTableView.backgroundView = noSearchContentFoundView
        trendingTableView.backgroundView?.isHidden = true
        trendingTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.trendingTableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 50.0, 0.0)
        switch useCase {
        case 1:
            if let name = newsSource?.sourceName {
                self.navigationItem.title = "Headlines From \(name)!"
            } else {
                self.navigationItem.title = "Headlines From The Source!"
            }
            
        default:
            self.navigationItem.title = "Headlines From All Sources!"
        }
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        topHeadlinesSearchBar.delegate = self
        trendingTableView.dataSource = self
        trendingTableView.delegate = self
        trendingTableView.tableFooterView = UIView(frame: .zero)
        topHeadlinesSearchBar.returnKeyType = .done
        topHeadlinesSearchBar.placeholder = searchPlaceHolder
        switch useCase {
        case 1:
            getNewsSourcesApiFetching(source: newsSource!, query: searchText)
        default:
            getTopHeadlinesApiFetching(forPage: pageNum,query: searchText)
        }
        
        
    }
    
    
    func getNewsSourcesApiFetching(source: NewsSourceModel,query: String?) {
        
        
        var parameters: [String: Any] = ["apiKey":"9906493df5204cd8a095bffc30acb720","sources": source.sourceId!]
        if query != nil && !(query?.isEmpty)!  {
            parameters["q"] = query!
        }
        populateData(parameters: parameters)
 
    }
 
    func getTopHeadlinesApiFetching(forPage page: Int,query: String?) {
        
  
        var parameters: [String: Any] = ["apiKey":"9906493df5204cd8a095bffc30acb720","page":page,"country":"us","pageSize":10]
        if query != nil && !(query?.isEmpty)!  {
            parameters["q"] = query!
        }
        populateData(parameters: parameters)
    
    }
    private func populateData(parameters: [String: Any]) {
        isLoading = true
        parentActivityIndicator?.startAnimating()
        GetNewsService.getNews(forUrl: ServiceUrl.sharedInstance.getTopHeadlinesNews, parameters: parameters, key: "articles", completionHandler: { (newsArray, isFinsihed, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                let duration = 2.0
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration, execute: {
                    self.childActivityIndicator?.stopAnimating()
                    self.parentActivityIndicator?.stopAnimating()
                    if error?._code == -1009 {
                        DropDownAlert.showMessage("Your Internet connection is lost!", withTextColor: Colors.pWhiteColorswift, backGroundColor: Colors.primaryColor, position: .bottom, duration: 3)
                    }  else {
                        DropDownAlert.showMessage("Something Unexpected Occurred!", withTextColor: Colors.pWhiteColorswift, backGroundColor: Colors.primaryColor, position: .bottom, duration: 3)
                    }
                })
                
            } else {
                DispatchQueue.global(qos: .userInitiated).async {
                    if newsArray.count == 0 {
                        self.moreItems = false
                        
                    }
                
                    for news in newsArray {
                        self.topHeadlinesTableDataSource.append(news)
                    }
                    
                    DispatchQueue.main.async {
                        self.isLoading = false
                        
                        print("Loaded" , self.topHeadlinesTableDataSource.count)
                        if self.searchText != nil && !(self.searchText?.isEmpty)! && newsArray.count == 0 {
                            self.trendingTableView.backgroundView?.isHidden = false
                        } else {
                            self.trendingTableView.backgroundView?.isHidden = true
                        }
                        
                        self.parentActivityIndicator?.stopAnimating()
                        self.childActivityIndicator?.stopAnimating()
                        self.trendingTableView.reloadData()
                    }
                }
                
            }
            
        })

    }
    @objc func reload(_ searchBar: UISearchBar) {
       searchText = searchBar.text
        guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces) != "" else {
            topHeadlinesTableDataSource.removeAll()
            
            switch useCase {
            case 1:
                getNewsSourcesApiFetching(source: newsSource!, query: nil)
                
            default:
                getTopHeadlinesApiFetching(forPage: pageNum, query: nil)
             
            }
            
            return
        }
    }
    func loadMoreItemsFromAPI() {
        pageNum += 1
        getTopHeadlinesApiFetching(forPage: pageNum,query: searchText)
    }


}
extension TopHeadlinesViewController:  UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces) != "" else {
            topHeadlinesTableDataSource.removeAll()
            switch useCase {
            case 1:
               getNewsSourcesApiFetching(source: newsSource!, query: searchText)
            default:
                getTopHeadlinesApiFetching(forPage: pageNum, query: searchText)
            }
            
            return
        }
        if query.count >= 3 {
            topHeadlinesTableDataSource.removeAll()
            self.searchText = query
            trendingTableView.reloadData()
            self.pageNum = 0
            switch useCase {
            case 1:
                getNewsSourcesApiFetching(source: newsSource!, query: searchText)
            default:
                getTopHeadlinesApiFetching(forPage: pageNum, query: searchText)
            }
            
        }
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
        perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.75)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        getTopHeadlinesApiFetching(forPage: pageNum, query: nil)
    }
}






extension TopHeadlinesViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((topHeadlinesTableDataSource.count * 2) - 1)
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

        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.sharedInstance.NewsTableViewCellIdentifier) as! NewsTableViewCell
        cell.selectionStyle = .none
        cell.setUpCell(news: topHeadlinesTableDataSource[indexPath.row/2])
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Identifiers.sharedInstance.TopHeadlinesTabStoryBoardIdentifier, bundle: nil)
        let ReadBlogVC = storyboard.instantiateViewController(withIdentifier: Identifiers.sharedInstance.ShowExternalWebsiteWebViewWindowIdentifier) as! ShowExternalWebsiteWebViewController
        ReadBlogVC.urlToLoad = topHeadlinesTableDataSource[indexPath.row/2].newsUrl
        self.navigationController?.pushViewController(ReadBlogVC, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {

            if !isLoading && moreItems {

                self.trendingTableView.tableFooterView = childActivityIndicator
                childActivityIndicator?.startAnimating()
                loadMoreItemsFromAPI()
                
                self.trendingTableView.tableFooterView?.isHidden = false
            }

        }

    }


}
