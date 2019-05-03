//
//  ImageCache.swift
//  Bingo Chat App
//
//  Created by Prateek on 20/08/17.
//  Copyright © 2017 14K. All rights reserved.
//

import UIKit
import Alamofire

let imgCache = NSCache<AnyObject, AnyObject>()


extension UIImageView {
    
    func loadImageUsingURLString(_ url : String?, placeholderPicName: String = "defaultPic"){
        
        if let url = url, !url.isEmpty {
            
            if let img = imgCache.object(forKey: url as AnyObject) as? UIImage{
                self.image = img
                return
            }
            
            self.image = UIImage(named: placeholderPicName)
            
            Alamofire.request(
                URL(string: url)!,
                method: .get,
                parameters: nil)
                .validate()
                .responseData { (response) -> Void in
                    guard response.result.isSuccess else {
                        print("Error while fetching remote rooms: \(String(describing: response.result.error))")
                        self.image = UIImage(named: placeholderPicName)
                        self.layer.masksToBounds =  true
                        return
                    }
                    
                    //print(response.result.value)
                    
                    if let imgData = UIImage(data: response.result.value!) {
                        
                        
                        imgCache.setObject(imgData, forKey: url as AnyObject)
                        
                        self.image = imgData
                        
                        if self.tag != 191 {
                            self.layer.cornerRadius = self.frame.size.height/2.0
                        }
                        self.layer.masksToBounds = true
                    }
                    
            }
            
        } else {
            self.image = UIImage(named: placeholderPicName)
            self.layer.cornerRadius = self.frame.size.height/2.0
            self.layer.masksToBounds =  true
            self.clipsToBounds = true
            return
        }
    }
    
    
}
