//
//  Posts.swift
//  Abled
//
//  Created by Brian Stacks on 8/7/16.
//  Copyright © 2016 Brian Stacks. All rights reserved.
//

import Foundation
import UIKit

class Posts {
    //var Id: Int
    var Name: String
    var Address: String
    var Type: String
    var Rating: Double
    var MyURL: String
    var myComment: String
    var myKey: String
    var userName: String
    var Id: String

    
    init( name: String?, address: String?, type: String?, rating: Double?, url: String?, comment: String?, key: String?, user: String?, id: String?) {
        self.Id = id!
        self.Name = name!
        self.Address = address!
        self.Type = type!
        self.Rating = rating!
        self.MyURL = url!
        self.myComment = comment!
        self.myKey = key!
        self.userName = user!

    }
    
    
}