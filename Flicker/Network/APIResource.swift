//
//  Network.swift
//  Flicker
//
//  Created by John Ellie Go on 7/15/21.
//

import Foundation
import Combine

protocol APIResource {
    associatedtype ModelType: Decodable
    var methodPath: String { get }
    var queryItems: [URLQueryItem] { get }
}
 
extension APIResource {
    var url: URL {
        var components = URLComponents(string: "https://www.flickr.com")!
        components.path = methodPath
        components.queryItems = queryItems
        
        return components.url!
    }
}

// MARK: - API Request
class APIRequest<Resource: APIResource> {
    let resource: Resource
    var currentTask: URLSessionTask?
    
    init(resource: Resource) {
        self.resource = resource
    }
}

extension APIRequest: NetworkRequest {
    func decode(_ data: Data) -> Resource.ModelType? {
        let decoder = JSONDecoder()
        let response = try? decoder.decode(Resource.ModelType.self, from: data)
        
        if let result = response {
            return result
        }
        
        return nil
    }

    func execute(withCompletion completion: @escaping (Resource.ModelType?) -> Void) {
        load(resource.url, withCompletion: completion)
    }
    
    func cancelTask() {
        currentTask = nil
    }
}
