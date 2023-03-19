//
//  Extensions.swift
//  Galleri
//
//  Created by Michael Enger on 18/03/2023.
//

import Foundation

// Inspired by: https://stackoverflow.com/a/27722526
extension URL {
    /// The content type of the resource.
    var contentType: String? { (try? resourceValues(forKeys: [.contentTypeKey]))?.contentType?.identifier }

    /// Whether the resource is an image.
    var isImage: Bool {
        let contentType = try? resourceValues(forKeys: [.contentTypeKey]).contentType

        for superType in contentType!.supertypes {
            if superType.identifier == "public.image" {
                return true
            }
        }

        return false
    }
}
