//
//  Media.swift
//  Galleri
//
//  Created by Michael Enger on 19/03/2023.
//

import SwiftUI
import Observation

/// A media item.
@Observable class Media: Identifiable {
    /// ID of the media item,
    let id: String

    /// URL used to load the media item.
    let url: URL

    /// Filename of the media item.
    var filename: String {
        get { return url.lastPathComponent }
    }

    /// Image representation of the media item.
    public private(set) var image: NSImage

    /// Whether the media item is an animated image.
    var type: MediaType {
        get { return url.isAnimatedImage ? .AnimatedImage : .StaticImage }
    }

    /// Size of the media item.
    var size: CGSize {
        get { return image.size }
    }

    /// Create a new media item based on a given URL.
    convenience init(_ url: URL) {
        self.init(
            id: UUID().uuidString,
            url: url)
    }

    /// Create a new media item based on a given ID and URL.
    init(id: Media.ID, url: URL) {
        self.id = id
        self.url = url
        self.image = NSImage(contentsOf: url)!
    }

    /// Creation date of the media file.
    var creationDate: Date? {
        let attributes = try? FileManager.default.attributesOfItem(atPath: self.url.path(percentEncoded: false))
        return attributes?[FileAttributeKey.creationDate] as! Date?
    }
}
