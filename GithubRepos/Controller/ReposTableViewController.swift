//
//  ViewController.swift
//  GithubRepos
//
//  Created by PaulCiudin on 13/06/2020.
//  Copyright © 2020 PaulCiudin. All rights reserved.
//

import UIKit
import SwiftyJSON

class RepositoriesViewController: UIViewController {
    
    @IBOutlet weak var reposTableView: UITableView!
    
    // MARK: TO DO: Decode to Repos
    var repos: [Repositories] = [Repositories]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        reposTableView.delegate = self
        reposTableView.dataSource = self
        
        APIManager.instance.fetchAndroidRepos() { jsonData in

            jsonData.forEach { (value, json) in
                let repo = Repositories()
                repo.configure(with: json)
                self.repos.append(repo)
            }
            
            DispatchQueue.main.async {
                self.reposTableView.reloadData()
            }
        }
    }

    
  
        
}

extension RepositoriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell")  else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = repos[indexPath.row].fullName
        cell.detailTextLabel?.text = repos[indexPath.row].description

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }
}


