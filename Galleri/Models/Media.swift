//
//  Media.swift
//  Galleri
//
//  Created by Michael Enger on 19/03/2023.
//

import Foundation

/// A media item.
struct Media: Identifiable, Codable {
    /// ID of the media item,
    public private(set) var id: UUID

    /// URL used to load the media item.
    public private(set) var url: URL

    /// Create a new media item based on a given URL.
    init(_ url: URL) {
        self.id = UUID()
        self.url = url
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
