//
//  DribbbleAPI.swift
//  Snubbble
//
//  Created by ViNiT. on 4/17/15.
//  Copyright (c) 2015 ViNiT. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    
    class func asyncLoadShotImage(shot: Shot, imageView : UIImageView){
        
        let downloadQueue = dispatch_queue_create("com.swityOS.processsdownload", nil)
        
        dispatch_async(downloadQueue) {
            
            var data = NSData(contentsOfURL: NSURL(string: shot.imageUrl)!)
            
            var image : UIImage?
            if data != nil {
                shot.imageData = data
                image = UIImage(data: data!)!
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                imageView.image = image
            }
        }
    }
    
    class func asyncLoadUserImage(user: User, imageView : UIImageView){
        
        let downloadQueue = dispatch_queue_create("com.swityOS.processsdownload", nil)
        
        dispatch_async(downloadQueue) {
            
            var data = NSData(contentsOfURL: NSURL(string: user.avatarUrl)!)
            
            var image : UIImage?
            if data != nil {
                image = UIImage(data: data!)!
                user.avatarData = data
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                imageView.image = image
            }
        }
    }
    
    class func getStringFromJSON(data: NSDictionary, key: String) -> String{
        
        let info : AnyObject? = data[key]
        
        if let info = data[key] as? String {
            return info
        }
        return ""
    }
    
    class func stripHTML(str: NSString) -> String {
        
        var stringToStrip = str
        var r = stringToStrip.rangeOfString("<[^>]+>", options:.RegularExpressionSearch)
        while r.location != NSNotFound {
            
            stringToStrip = stringToStrip.stringByReplacingCharactersInRange(r, withString: "")
            r = stringToStrip.rangeOfString("<[^>]+>", options:.RegularExpressionSearch)
        }
        
        return stringToStrip as String
    }
    
    class func formatDate(dateString: String) -> String {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = formatter.dateFromString(dateString)
        
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.stringFromDate(date!)
    }


}
