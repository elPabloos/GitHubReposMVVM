//
//  RepoCell.swift
//  GithubRepos
//
//  Created by PaulCiudin on 15/06/2020.
//  Copyright © 2020 PaulCiudin. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {
    
    private var activityIndicator = UIActivityIndicatorView()
    var repositoryCellVM: RepositoryCellViewModel? {
        didSet {
            self.textLabel?.text = repositoryCellVM?.titleText
            self.detailTextLabel?.text = repositoryCellVM?.detailedText
            self.accessoryType = .disclosureIndicator
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        if let frame = self.imageView?.bounds {
            activityIndicator.frame = frame
        }
        self.imageView?.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

extension RepositoryCell {
    
    func startActivityIndicatorAnimation() {
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicatorAnimation() {
        activityIndicator.stopAnimating()
    }
    
}

