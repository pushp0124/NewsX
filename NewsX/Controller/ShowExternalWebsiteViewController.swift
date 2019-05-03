//
//  ShowExternalWebsiteViewController.swift
//  NewsX
//
//  Created by Push_Parn on 03/05/19.
//  Copyright © 2019 abes. All rights reserved.
//

import UIKit

class ShowExternalWebsiteWebViewController: UIViewController {
    
    @IBOutlet weak var blogWebView: UIWebView!
    var childActivityIndicator: UIActivityIndicatorView?
    
    @IBOutlet weak var readBlogContentView: UIView!
    
    
    var urlToLoad: String?
    private func setUpUI() {
        
        let center = readBlogContentView.center
        let frameForChild = CGRect(x: CGFloat(0), y: center.y , width: readBlogContentView.bounds.width, height: CGFloat(44))
     
        childActivityIndicator = ActivityIndicatorView.simpleActivityIndicatorView(frame: frameForChild, type: .gray, color: nil)
        blogWebView.delegate = self
        readBlogContentView.addSubview(childActivityIndicator!)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        childActivityIndicator?.startAnimating()
        let replacedURl = urlToLoad?.replacingOccurrences(of: "http://", with: "https://") ?? ""
        let request = URLRequest(url: URL(string: replacedURl)!)
        
        blogWebView.loadRequest(request)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ShowExternalWebsiteWebViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
    
        childActivityIndicator?.stopAnimating()
    }
}
