//
//  ApiService.swift
//  MyYouTube
//
//  Created by Paul Dong on 23/09/17.
//  Copyright © 2017 Paul Dong. All rights reserved.
//

import UIKit

class ApiService: NSObject {
    
    static let sharedInstance = ApiService()
    
    let baseUrl = "https://s3-us-west-2.amazonaws.com/youtubeassets"
    
    func fetchHomeFeed(completion: @escaping ([Video]) -> ()){
        let url = URL(string: "\(baseUrl)/home.json")
        fetchFeedForUrl(url: url!, completion: completion)
    }
    
    func fetchTrendingFeed(completion: @escaping ([Video]) -> ()){
        let url = URL(string: "\(baseUrl)/trending.json")
        fetchFeedForUrl(url: url!, completion: completion)
    }
    
    func fetchSubscriptionFeed(completion: @escaping ([Video]) -> ()){
        let url = URL(string: "\(baseUrl)/subscriptions.json")
        fetchFeedForUrl(url: url!, completion: completion)
    }
    
    func fetchFeedForUrl(url: URL, completion: @escaping ([Video]) -> ()){
        URLSession.shared.dataTask(with: url) { (data, response, error) in

            if let err = error {
                print(err)
                return
            }
            
            do {
                if let unwrappedData = data, let jsonDictionaries = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? [[String: AnyObject]] {
                    
                    DispatchQueue.main.async {
                        completion(jsonDictionaries.map({ return Video(dictionary: $0) }))
                    }

                }
            }catch let jsonError {
                print(jsonError)
            }
            
            }.resume()

    }
}
