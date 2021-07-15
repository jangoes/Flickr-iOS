//
//  SystemImage.swift
//  Flicker
//
//  Created by John Ellie Go on 7/15/21.
//

import SwiftUI

enum SystemImage: String {
    case starCirle = "star.circle"
    case starCircleFill = "star.circle.fill"
    case photo = "photo"
    case photoFill = "photo.fill"
    
    var image: Image {
        Image(systemName: self.rawValue)
    }
}
