//
//  DribbbleAPI.swift
//  Snubbble
//
//  Created by ViNiT. on 4/17/15.
//  Copyright (c) 2015 ViNiT. All rights reserved.
//

class DribbbleAPI {
    
    let accessToken = "dc5a71673c52e02fb510a7bf514789a90c1d9c169c13edbd92e5e19ba74a5f56"
    
    func loadShots(shotsUrl: String, completion: (([Shot]) -> Void)!) {
        
        let urlString = shotsUrl + "?access_token=" + accessToken + "&page=1&per_page=100"
        
        let session = NSURLSession.sharedSession()
        let shotsUrl = NSURL(string: urlString)
        
        let task = session.dataTaskWithURL(shotsUrl!){
            (data, response, error) -> Void in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    let shotsData = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSArray
                    
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
                } catch{
                    print(error)
                }
                
                
            }
        }
        
        task.resume()
    }
    
    func loadComments(commentsUrl: String, completion: (([Comment]) -> Void)!) {
        
        let urlString = commentsUrl + "?access_token=" + accessToken
        
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: urlString)
        let task = session.dataTaskWithURL(url!){
            (data, response, error) -> Void in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                
                do{
                    let commentsData = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSArray
                    
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
                }catch{
                    print(error)
                }
                
                
            }
        }
        
        task.resume()
    }
    
    func loadUsers(usersUrl: String, completion: (([User]) -> Void)!) {
        
        let urlString = usersUrl + "?access_token=" + accessToken
        
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: urlString)
        let task = session.dataTaskWithURL(url!){
            (data, response, error) -> Void in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                
                do{
                    let usersData = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSArray
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
                }catch{
                    print(error)
                }
                
                
            }
        }
        
        task.resume()
    }
}