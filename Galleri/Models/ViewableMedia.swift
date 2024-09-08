//
//  ViewableMedia.swift
//  Galleri
//
//  Created by Michael Enger on 08/09/2024.
//

import Foundation

/// A single (or more) media which can be viewed.
class ViewableMedia {
    /// The media itself.
    public private(set) var mediaItems: [Media]

    /// Size of the media item.
    var size: CGSize {
        get {
            var fullsize = CGSize()

            for item in mediaItems {
                fullsize.height = max(fullsize.height, item.size.height)
                fullsize.width = fullsize.width + item.size.width
            }

            return fullsize
        }
    }

    init(_ media: Media) {
        self.mediaItems = [media]
    }

    init(_ first: Media, _ second: Media) {
        self.mediaItems = [first, second]
    }
}

