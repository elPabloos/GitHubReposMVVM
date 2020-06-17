//
//  DetailedRepositoryCell.swift
//  GithubRepos
//
//  Created by PaulCiudin on 17/06/2020.
//  Copyright © 2020 PaulCiudin. All rights reserved.
//

import UIKit

class DetailedRepositoryCell: UITableViewCell {
    
    var repositoryCellVM: RepositoryCellViewModel? {
        didSet {
            self.textLabel?.text = repositoryCellVM?.titleText
            self.detailTextLabel?.text = repositoryCellVM?.detailedText
        }
    }
    
}
