//
//  Photos.swift
//  Flicker
//
//  Created by John Ellie Go on 7/15/21.
//

import SwiftUI

// MARK: - Wrapper
struct PhotosWrapper: Decodable {
    let photos: Photos
    let stat: String
}

// MARK: - Photos
struct Photos: Decodable {
    let photo: [Photo]
}

// MARK: - Photo
struct Photo: Identifiable, Decodable {
    let id: String
    let title: String
    let owner: String
    let imageUrl: String
    var isFavorite: Bool = false

    enum CodingKeys: String, CodingKey {
        case id, title, owner = "ownername", imageUrl = "url_m"
    }
}
