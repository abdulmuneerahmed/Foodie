//
//  Extension.swift
//  Foodie
//
//  Created by admin on 22/03/19.
//  Copyright © 2019 AcknoTech. All rights reserved.
//
import UIKit
import Alamofire
import AlamofireImage

//Extension For Image

let imageCache = NSCache<AnyObject, AnyObject>()

public class CustomImageView: UIImageView {
    
    var imageUrlString:String?
    
    func loadImageUsingUrlString(urlString: String) {
        
        imageUrlString = urlString
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = imageFromCache
            return
        }
        
        
        Alamofire.request(urlString).responseImage { (response) in
            guard let imageToCache = response.result.value else{return}
            if self.imageUrlString == urlString{
                self.image = imageToCache
            }
            imageCache.setObject(imageToCache,forKey:urlString as AnyObject)
            
            
        }
        
    }
    
}
