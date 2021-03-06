//
//  Post.swift
//  InstaCover
//
//  Created by Juan M Mariscal on 4/15/17.
//  Copyright © 2017 Mariscal Development. All rights reserved.
//

import Foundation

struct Post {
    
    let user: User
    let imageUrl: String
    let caption: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
    }
}
