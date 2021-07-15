//
//  NetworkRequest.swift
//  Flicker
//
//  Created by John Ellie Go on 7/15/21.
//

import Foundation

protocol NetworkRequest: AnyObject {
    associatedtype ModelType
    func decode(_ data: Data) -> ModelType?
    func execute(withCompletion completion: @escaping (ModelType?) -> Void)
    var currentTask: URLSessionTask? { get set }
}

extension NetworkRequest {
    func load(_ url: URL, data: Data? = nil, withCompletion completion: @escaping (ModelType?) -> Void) {
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 60
        
        if let data = data {
            request.httpBody = data
        }
        
        currentTask = URLSession.shared.dataTask(with: request) { [weak self] (data, _, _) -> Void in
            guard let data = data, let value = self?.decode(data) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            DispatchQueue.main.async { completion(value) }
        }
        
        currentTask?.resume()
    }
    
}
