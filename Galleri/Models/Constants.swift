//
//  Constants.swift
//  Galleri
//
//  Created by Michael Enger on 19/03/2023.
//

import Foundation

/// Order which the media can be sorted by.
enum SortOrder: String {
    case date = "date"
    case kind = "kind"
    case name = "name"
    case path = "path"
    case random = "random"
    case size = "size"
}

/// The zoom mode for a media file.
enum ZoomMode {
    case ActualSize
    case Dynamic
    case FitHeight
    case FitWidth
}

/// Holds the default settings for the app.
enum DefaultSettings {
    static let sortBy = SortOrder.name
}

let ZOOM_INTERVAL: CGFloat = 0.1
let SCALE_INTERVAL: CGFloat = 0.1
let SCALE_MIN: CGFloat = 1.0
let SCALE_MAX: CGFloat = 10.0
