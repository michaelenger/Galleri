//
//  Settings.swift
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

/// Holds the default settings for the app.
enum DefaultSettings {
    static let sortBy = SortOrder.name
}
