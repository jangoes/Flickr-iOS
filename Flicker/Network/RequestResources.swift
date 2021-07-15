//
//  RequestResources.swift
//  Flicker
//
//  Created by John Ellie Go on 7/15/21.
//

import Foundation

struct PhotosResource: APIResource {
    typealias ModelType = PhotosWrapper
    var methodPath = "/services/rest/"
    var queryItems = [
        URLQueryItem(name: "method", value: "flickr.people.getPublicPhotos"),
        URLQueryItem(name: "api_key", value: "d3c8cb57b60027413cd520f5853d01b7"),
        URLQueryItem(name: "user_id", value: "65789667@N06"),
        URLQueryItem(name: "extras", value: "url_m,owner_name"),
        URLQueryItem(name: "format", value: "json"),
        URLQueryItem(name: "nojsoncallback", value: "1")
    ]
}
