//
//  DribbbleAPI.swift
//  Snubbble
//
//  Created by ViNiT. on 4/17/15.
//  Copyright (c) 2015 ViNiT. All rights reserved.
//

import Foundation

class DribbbleAPI {
    
    let accessToken = "dc5a71673c52e02fb510a7bf514789a90c1d9c169c13edbd92e5e19ba74a5f56"
    
    func loadShots(shotsUrl: String, completion: (([Shot]) -> Void)!) {
        
        var urlString = shotsUrl + "?access_token=" + accessToken + "&page=1&per_page=100"
        
        let shotsUrl = NSURL(string: urlString)
        
        var task = NSURLSession.sharedSession().dataTaskWithURL(shotsUrl!){ (data, response, error) -> Void in
            
            if error != nil {
                println(error.localizedDescription)
            } else {
                
                
                var error : NSError?
                
                var shotsData = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &error) as! NSArray
                
                var shots = [Shot]()
                for shot in shotsData{
                    let shot = Shot(data: shot as! NSDictionary)
                    shots.append(shot)
                }
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(shots)
                    }
                }
                
            }
        }
        
        task.resume()
    }
    
    func loadComments(commentsUrl: String, completion: (([Comment]) -> Void)!) {
        
        var urlString = commentsUrl + "?access_token=" + accessToken
        
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: urlString)
        var task = session.dataTaskWithURL(url!){
            (data, response, error) -> Void in
            
            if error != nil {
                println(error.localizedDescription)
            } else {
                
                
                var error : NSError?
                
                var commentsData = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &error) as! NSArray
                
                var comments = [Comment]()
                for commentData in commentsData{
                    let comment = Comment(data: commentData as! NSDictionary)
                    comments.append(comment)
                }
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(comments)
                    }
                }
                
            }
        }
        
        task.resume()
    }
    
    func loadUsers(usersUrl: String, completion: (([User]) -> Void)!) {
        
        var urlString = usersUrl + "?access_token=" + accessToken
        
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: urlString)
        var task = session.dataTaskWithURL(url!){
            (data, response, error) -> Void in
            
            if error != nil {
                println(error.localizedDescription)
            } else {
                
                
                var error : NSError?
                
                var usersData = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &error) as! NSArray
                
                var users = [User]()
                for userData in usersData{
                    let user = User(data: userData["followee"] as! NSDictionary)
                    users.append(user)
                }
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(users)
                    }
                }
            }
        }
        
        task.resume()
    }
}
