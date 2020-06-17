//
//  ViewController.swift
//  GithubRepos
//
//  Created by PaulCiudin on 16/06/2020.
//  Copyright © 2020 PaulCiudin. All rights reserved.
//

import UIKit

protocol DetailedRepositoryDelegate {
    func updateDetailedView(withContent: String)
}

class RepositoriesViewController: UIViewController {
    
    @IBOutlet weak var reposTableView: UITableView!
    
    var detailedRepositoryDelegate: DetailedRepositoryDelegate?
    
    lazy var repositoryViewModel: RepositoryViewModel = {
        return RepositoryViewModel()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initRepositoryViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        
//        if let indexPath = self.reposTableView.indexPathForSelectedRow {
//            reposTableView.deselectRow(at: indexPath, animated: false)
//        }
    }
    
    func initRepositoryViewModel() {
        repositoryViewModel.fetchAndroidReposData()
        repositoryViewModel.reloadTableViewClosure = { [weak self] in
            self?.updateTableView()
        }
    }
    
    private func updateTableView() {
        DispatchQueue.main.async {
            self.reposTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? DetailedRepositoryController else {
            return
        }
        detailedRepositoryDelegate = destinationVC
        destinationVC.repositoryVM = repositoryViewModel
        
    }
    
}

extension RepositoriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryViewModel.numberOfRepoCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as? RepositoryCell else {
            return UITableViewCell()
        }
        
        cell.repositoryCellVM = repositoryViewModel.getCellViewModel(at: indexPath.row)
        
        repositoryViewModel.fetchImageForCell(at: indexPath.row, completion: { (image) in
            DispatchQueue.main.async {
                cell.imageView?.image = image
                cell.stopActivityIndicatorAnimation()
                cell.layoutSubviews()
            }
            
        })

        return cell
    }
    
    // MARK: Work on smoothness
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let nrOfCells = repositoryViewModel.numberOfRepoCells
        let lastElementIndex =  nrOfCells - 5
        
        if indexPath.row == lastElementIndex {
            repositoryViewModel.fetchAndroidReposData()
        }
        
        if indexPath.row == lastElementIndex {
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        repositoryViewModel.createDetailedRepoCellVM(repoIndex: indexPath.row)
        
        repositoryViewModel.fetchReadMeRepoData(forRepositoryWithIndex: indexPath.row) { (markdownString) in
            self.detailedRepositoryDelegate?.updateDetailedView(withContent: markdownString)
        }
    }
    
}



