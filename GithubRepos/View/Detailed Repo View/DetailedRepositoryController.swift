//
//  DetailedRepositoryController.swift
//  GithubRepos
//
//  Created by PaulCiudin on 16/06/2020.
//  Copyright © 2020 PaulCiudin. All rights reserved.
//

import UIKit
import Down

class DetailedRepositoryController: UIViewController {
    
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var readMeView: UIView!
    
    
    var repoDict: [String : String] = [:]
    var repoDetails: [String] = RepositoryMetaDataModel().propertiesLabel(except: "avatarURL")
    
    var repositoryVM: RepositoryViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        
        repositoryVM?.reloadDetailedTVClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.detailsTableView.reloadData()
            }
        }
    }
    
    
}

extension DetailedRepositoryController: DetailedRepositoryDelegate, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryVM?.numberOfDetailedRepoCells ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailedTableViewCell", for: indexPath) as? DetailedRepositoryCell else {
            return UITableViewCell()
        }
        
        cell.repositoryCellVM = repositoryVM?.getDetailedRepoCell(at: indexPath.row)
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    
    func updateDetailedView(withContent: String) {
        DispatchQueue.main.async {
            guard let downView = try? DownView(frame: self.readMeView.bounds, markdownString: withContent, options: .safe) else { return  }
            self.readMeView.addSubview(downView)
           
        }
    }
    
    
}
