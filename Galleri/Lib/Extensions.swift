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

    /// Whether the resource is an animated image.
    var isAnimatedImage: Bool {
        return contentType == "com.compuserve.gif"
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
}
