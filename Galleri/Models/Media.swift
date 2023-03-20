//
//  Media.swift
//  Galleri
//
//  Created by Michael Enger on 19/03/2023.
//

import SwiftUI

/// A media item.
struct Media: Identifiable {
    /// ID of the media item,
    let id: String

    /// URL used to load the media item.
    let url: URL

    /// Image representation of the media item.
    public private(set) var image: NSImage?

    /// Create a new media item based on a given URL.
    init(_ url: URL) {
        self.id = UUID().uuidString
        self.url = url
        self.image = NSImage(contentsOf: url)
    }

    /// Create a new media item based on a given ID and URL.
    init(id: Self.ID, url: URL) {
        self.id = id
        self.url = url
        self.image = NSImage(contentsOf: url)
    }

    /// Creation date of the media file.
    var creationDate: Date? {
        let attributes = try? FileManager.default.attributesOfItem(atPath: self.url.path(percentEncoded: false))
        return attributes?[FileAttributeKey.creationDate] as! Date?
    }

    /// Size of the media file.
    var size: Float {
        let attributes = try? FileManager.default.attributesOfItem(atPath: self.url.path(percentEncoded: false))
        return (attributes?[FileAttributeKey.size] as! NSNumber).floatValue
    }
}
