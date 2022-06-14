//
//  NetworkManager.swift
//  UnsplashApp
//
//  Created by Oleksandr Kachkin on 09.06.2022.
//

import Foundation

enum NetworkManagerError: Error {
  case badResponse(URLResponse?)
  case badData
  case badLocalUrl
}

fileprivate struct APIResponse: Codable {
  let results: [Post]
}

class NetworkManager {
  
  static var shared = NetworkManager()
  
  func components() -> URLComponents {
    var comp = URLComponents()
    comp.scheme = "https"
    comp.host = "api.unsplash.com"
    return comp
  }
  
  func posts(query: String, completion: @escaping ([Post]?, Error?) -> (Void)) {
    var comp = components()
    comp.path = "/search/photos"
    comp.queryItems = [
      URLQueryItem(name: "query", value: query)
    ]
    let req = request(url: comp.url!)
    
    let task = session.dataTask(with: req) { data, response, error in
      if let error = error {
        completion(nil, error)
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
        completion(nil, NetworkManagerError.badResponse(response))
        return
      }
      
      guard let data = data else {
        completion(nil, NetworkManagerError.badData)
        return
      }
      
      do {
        let response = try JSONDecoder().decode(APIResponse.self, from: data)
        completion(response.results, nil)
      } catch let error {
        completion(nil, error)
      }
    }
    
    task.resume()
  }
  
  
  
}
