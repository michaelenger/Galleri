//
//  Constants.swift
//  Galleri
//
//  Created by Michael Enger on 19/03/2023.
//

import Foundation

/// The type of media.
enum MediaType {
    case AnimatedImage
    case StaticImage
}

/// The rotation mode when displaying the media file.
enum RotationMode {
    case Original
    case RotatedRight
    case RotatedLeft
    case UpsideDown
}

/// The scaling mode when displaying the media file.
enum ScalingMode {
    case ActualSize
    case Dynamic
    case Fill
    case Fit
}

/// Amount of time to wait between switching slides.
enum SlideshowTime {
    case OneSecond
    case ThreeSeconds
    case FiveSeconds
    case TenSeconds
}

/// Order which the media can be sorted by.
enum SortOrder: String {
    case date = "date"
    case kind = "kind"
    case name = "name"
    case path = "path"
    case random = "random"
}

/// Mode to view media in - single or double.
enum ViewMode {
    case Single
    case DoubleLTR
    case DoubleRTL
}

/// Holds the default settings for the app.
let DEFAULT_SORT_BY = SortOrder.name

/// Zoom values.
let ZOOM_INTERVAL: CGFloat = 0.1
let ZOOM_MIN: CGFloat = 1.0
let ZOOM_MAX: CGFloat = 10.0
