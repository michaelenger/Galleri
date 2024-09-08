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
    public private(set) var media: Media

    /// Size of the media item.
    var size: CGSize {
        get { return media.size }
    }

    init(_ media: Media) {
        self.media = media
    }
}

