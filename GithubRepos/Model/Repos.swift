//
//  Repos.swift
//  GithubRepos
//
//  Created by PaulCiudin on 13/06/2020.
//  Copyright © 2020 PaulCiudin. All rights reserved.
//

import Foundation
import SwiftyJSON

class Repositories {
    var fullName: String?
    var description: String?
    var watchers: Int?
    
    func configure(with json: JSON) {
        fullName = json["full_name"].string
        watchers = json["watchers"].int
        description = json["description"].string
        
    }
}
