//
//  APIManager.swift
//  GithubRepos
//
//  Created by PaulCiudin on 15/06/2020.
//  Copyright © 2020 PaulCiudin. All rights reserved.
//

import Foundation

class APIManager {
    
    static let instance = APIManager()

    let baseURL = "https://api.github.com/"
    let readMebaseURL = "https://raw.githubusercontent.com/"
    
    static var pageNr = 0
    
    private static var androidSearchURL: String {
        return "https://api.github.com/search/repositories?q=android&sort=stars&order=desc&page=\(APIManager.pageNr)"
    }
    
    func fetchAndroidRepos(completion: @escaping (Data)->() = { _ in} ) {
        fetchDataFrom(url: getURL(string: APIManager.androidSearchURL)) { jsonData in
            completion(jsonData)
        }
    }
    
    func fetchDataFrom(url: String, completion: @escaping (Data) -> () = { _ in} ) {
        fetchDataFrom(url: getURL(string: url)) { data in
            completion(data)
        }
    }
    
    private func fetchDataFrom(url: URL?, completion: @escaping (Data) -> () = { _ in} )  {
        
        guard let url = url else {
            return
        }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) {data, serverResponse, error in
            
            guard let response = serverResponse as? HTTPURLResponse, (200...209).contains(response.statusCode) else {
                print("Server error: \(String(describing: serverResponse))")
                return
            }
            
            if let data = data {
                DispatchQueue.main.async {
                }
                completion(data)
            } else if let requestError = error {
                print("Error fetching newest news: \(requestError)")
            } else {
                print("Unexpected error with the request")
            }
        }
        
        task.resume()
        
    }
    
    private func getURL(string: String) -> URL? {
        guard let url = URLComponents(string: string)?.url else {
            return nil
        }
        
        return url
    }
}
