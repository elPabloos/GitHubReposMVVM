//
//  RepositoryViewModel.swift
//  GithubRepos
//
//  Created by PaulCiudin on 16/06/2020.
//  Copyright © 2020 PaulCiudin. All rights reserved.
//

import Foundation
import SwiftyJSON

class RepositoryViewModel {
    
    var reloadTableViewClosure: (()->())?
    var reloadDetailedTVClosure: (() -> ())?
    
    private let internalQueue = DispatchQueue.init(label: "imageRepoQueue")
    
    private var repositories: [RepositoryDataModel] = [] {
        didSet {
            //reloadTableViewClosure?()
        }
    }
    
    private var repoCellViewModels = [RepositoryCellViewModel] () {
        didSet {
            reloadTableViewClosure?()
        }
    }
    
    private var detailedRepoCellVMs = DetailedRepositoryCellContainer() {
        didSet {
            if detailedRepoCellVMs.detailedCellsContainer.count == 4 {
            }
            reloadDetailedTVClosure?()
        }
        
    }

    var numberOfRepoCells: Int {
        return repoCellViewModels.count
    }
    
    var numberOfDetailedRepoCells: Int {
        return detailedRepoCellVMs.detailedCellsContainer.count
    }
    
    // MARK: Detailed Repo TableView Cell methods
    
    func getDetailedRepoCell(at index: Int) -> DetailedRepositoryCellVM {
        //createDetailedRepoCellVM(repoDict: repositories[index].metaData?.metaDataDict ?? [:])
        return detailedRepoCellVMs.detailedCellsContainer[index]
    }
    
    func createDetailedRepoCellVM(repoIndex: Int)  {
        guard let repoDict = repositories[repoIndex].metaData?.metaDataDict else {
            return
        }
        
        var detailedCells: [DetailedRepositoryCellVM] = []
        for (key,value) in repoDict {
            detailedCells.append(DetailedRepositoryCellVM(titleText: key ,                                                    detailedText: String(value) ))
        }
       detailedRepoCellVMs = DetailedRepositoryCellContainer(detailedCells: detailedCells)
    }
    
    // MARK:  Repo TableView Cell methods
    
    func getCellViewModel(at indexPath: Int) -> RepositoryCellViewModel {
        return repoCellViewModels[indexPath]
    }
    
    func fetchImageForCell(at index: Int, completion: @ escaping (UIImage) -> () ) {
        getImage(url: repositories[index].metaData?.avatarURL ?? "") { image in
            completion(image)
        }
    }
    
    private func createRepoCellViewModel(repository: RepositoryDataModel) -> RepositoryCellViewModel {
        
        return RepositoryCellViewModel(titleText: repository.fullName ?? "",
                                       detailedText: repository.description ?? "")
        
    }
    
    // MARK: TableView methods

    func fetchAndroidReposData() {
        APIManager.pageNr += 1
        APIManager.instance.fetchAndroidRepos() { data in
            guard let jsonData = self.decodeToJSON(data: data) else {
                return
            }
            
            self.configureDataModel(jsonData: jsonData)
        }
    }
    
    func fetchReadMeRepoData(forRepositoryWithIndex index: Int, completion: @escaping  (_ markdownString: String) -> () ) {
        
        let readMeURL =  APIManager.instance.readMebaseURL + (repositories[index].fullName ?? "n/a") + "/master/README.md"
        
        APIManager.instance.fetchDataFrom(url: readMeURL) { data in
            guard let string = String(data: data, encoding: .utf8) else {
                return
            }
                        
            completion(string )
        }
    }
    
    func loadImage(forRepoWithIndex index: Int, completion: @escaping (UIImage) -> () ) {
        getImage(url: repositories[index].metaData?.avatarURL ?? "") { image in
            completion(image)
        }
    }
    
    private func configureDataModel(jsonData: JSON) {
        
        var repos: [RepositoryDataModel] = []
        var reposCell: [RepositoryCellViewModel] = []
        
        jsonData["items"].forEach { (index, json) in
            let repo = RepositoryDataModel()
            repo.configure(with: json)
            repos.append(repo)
            
            let repoCell = createRepoCellViewModel(repository: repo)
            reposCell.append(repoCell)
        }
        self.repoCellViewModels.append(contentsOf: reposCell)
        self.repositories.append(contentsOf: repos)
        
    }
    
    private func initialiseDetailedRepoCell(repo: RepositoryDataModel) {
        createDetailedRepoCellVM(repoIndex: 0)
    }
    
    private func decodeToJSON(data: Data) -> JSON? {
           var jsonData: JSON?
           
           do {
               jsonData = try JSON(data: data)
           } catch {
               print("JSON decoding error: \(error)")
           }
           
           return jsonData
    }
    
    private func getImage(url: String, completion: @escaping (UIImage) -> () = {_ in } ) {
        APIManager.instance.fetchDataFrom(url: url) { data in
            guard let image = UIImage(data: data) else {
                self.internalQueue.async {
                    completion(UIImage())
                }
                return
            }
            self.internalQueue.async {
                completion(image)
            }
        }
    }
}



struct RepositoryCellViewModel {
    let titleText: String
    let detailedText: String
}

typealias DetailedRepositoryCellVM = RepositoryCellViewModel

struct DetailedRepositoryCellContainer {
    var detailedCellsContainer: [DetailedRepositoryCellVM] = []
    init() {}
    init(detailedCells: [DetailedRepositoryCellVM]) {
        detailedCellsContainer = detailedCells
    }
}
