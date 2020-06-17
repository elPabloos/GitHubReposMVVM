//
//  Repos.swift
//  GithubRepos
//
//  Created by PaulCiudin on 15/06/2020.
//  Copyright © 2020 PaulCiudin. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol MirrorProperties {
    func propertiesLabel() -> [String]
}

extension MirrorProperties {
    func propertiesLabel() -> [String] {
        return Mirror(reflecting: self).children.compactMap { $0.label }
    }
    
    func propertiesLabel(except labelValue: String) -> [String] {
        return Mirror(reflecting: self).children.compactMap {
            if $0.label != labelValue {
                return $0.label
            }
            return ""
        }
    }
    
    func propertiesValue() -> [Int] {
        return Mirror(reflecting: self).children.compactMap { $0.value as? Int }
    }
}

class RepositoryDataModel: MirrorProperties {
    
    var fullName: String?
    var description: String?
    
    var metaData: RepositoryMetaDataModel?
    var image: UIImage?
    
    func configure(with json: JSON) {
        fullName = json["full_name"].string
        description = json["description"].string
        
        metaData = RepositoryMetaDataModel(with: json)
    }
}

struct RepositoryMetaDataModel: MirrorProperties {

    var avatarURL: String?
    
    var metaDataDict: [String : Int] = [:]
    
    init() {}
    
    init(with json: JSON) {
        metaDataDict["watchers"] = json["watchers"].int
        metaDataDict["forks"] = json["forks"].int
        metaDataDict["stargazers"] = json["stargazers_count"].int
        metaDataDict["openIssues"] = json["open_issues"].int
        avatarURL = json["owner"]["avatar_url"].string
    }
}
