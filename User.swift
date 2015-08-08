//
//  DribbbleAPI.swift
//  Snubbble
//
//  Created by ViNiT. on 4/17/15.
//  Copyright (c) 2015 ViNiT. All rights reserved.
//

import Foundation


class User {
    
    var userId : Int!
    var avatarUrl : String!
    var name : String!
    var location : String!
    var followingCount : Int!
    var followersCount : Int!
    var shotsCount : Int!
    
    var shotsUrl : String!
    var followingUrl : String!
    
    var avatarData : NSData?
    
    init(data : NSDictionary){
    
        self.userId = data["id"] as! Int
        self.name = Utils.getStringFromJSON(data, key: "name")
        self.avatarUrl = Utils.getStringFromJSON(data, key: "avatar_url")
        
        self.location = Utils.getStringFromJSON(data, key: "location")
        self.followingCount = data["followings_count"] as! Int
        self.followersCount = data["followers_count"] as! Int
        self.shotsCount = data["shots_count"] as! Int
        
        self.shotsUrl = Utils.getStringFromJSON(data, key: "shots_url")
        self.followingUrl = Utils.getStringFromJSON(data, key: "following_url")
    }
    

}