//
//  Extensions.swift
//  Galleri
//
//  Created by Michael Enger on 18/03/2023.
//

import SwiftUI

// From: https://www.hackingwithswift.com/quick-start/swiftui/how-to-run-some-code-when-state-changes-using-onchange
extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}

// Inspired by: https://stackoverflow.com/a/27722526
extension URL {
    /// The content type of the resource.
    var contentType: String? {
        let contentType = try? resourceValues(forKeys: [.contentTypeKey]).contentType

        return contentType?.identifier
    }

    var creationDate: Date? {
        let attributes = try? FileManager.default.attributesOfItem(atPath: self.path(percentEncoded: false))
        return attributes?[FileAttributeKey.creationDate] as! Date?
    }

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

    /// Size of the file pointed to by the URL.
    var size: Float {
        let attributes = try? FileManager.default.attributesOfItem(atPath: self.path(percentEncoded: false))
        return (attributes?[FileAttributeKey.size] as! NSNumber).floatValue
    }
}
