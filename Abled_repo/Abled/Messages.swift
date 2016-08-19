//
//  Messages.swift
//  Abled
//
//  Created by Brian Stacks on 8/13/16.
//  Copyright © 2016 Brian Stacks. All rights reserved.
//

import Foundation

class Messages: NSObject{
    
    var name: String
    var text: String

    
    init(name: String, text: String) {
        self.name = name
        self.text = text

    }
}