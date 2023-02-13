//
//  Image.swift
//  HedgehogTestApp
//
//  Created by murphy on 10.02.2023.
//

import Foundation
import UIKit

typealias Images = [Image]

struct Image {
    let thumbnailSource: String
    let originalSource: String
    var original: UIImage?
    var thumbnail: UIImage?
    let width: Int
    let height: Int
    let source: String
    
    init(imageData: ImageData, original: UIImage? = nil, thumbnail: UIImage? = nil) {
        self.thumbnailSource = imageData.thumbnail
        self.originalSource = imageData.original
        self.thumbnail = thumbnail
        self.width = imageData.originalWidth
        self.height = imageData.originalHeight
        self.source = imageData.link
    }
}

enum ImageQuality {
    case original
    case thumbnail
}
