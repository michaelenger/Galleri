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

    /// Image representation of the media item.
    public private(set) var image: NSImage

    /// Zoom mode of the media.
    var zoomMode: ZoomMode = .Fit

    /// Create a new media item based on a given URL.
    convenience init(_ url: URL) {
        self.init(
            id: UUID().uuidString,
            url: url)
    }

    /// Create a new media item based on a given ID and URL.
    init(id: Media.ID, url: URL, zoomMode: ZoomMode = .Fit) {
        self.id = id
        self.url = url
        self.zoomMode = zoomMode
        self.image = NSImage(contentsOf: url)!
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
