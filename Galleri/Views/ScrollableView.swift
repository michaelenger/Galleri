//
//  ScrollableView.swift
//  Galleri
//
//  Created by Michael Enger on 18/03/2023.
//

import SwiftUI

/// An image view that displays the media and allows you to scroll, if necessary.
struct ScrollableView: View {
    var media: Media
    @Binding var zoomMode: ZoomMode

    var body: some View {
        GeometryReader { geometry in
            let frameSize = desiredFrameSize(geometry: geometry)

            ScrollView([.horizontal, .vertical]) {
                MediaView(media: self.media)
                    .frame(width: frameSize.width, height: frameSize.height)
            }
        }
    }
}

extension ScrollableView {
    /// Get the desired frame size based on the image's zoom mode.
    func desiredFrameSize(geometry: GeometryProxy) -> CGSize {
        switch zoomMode {
        case .ActualSize:
            return media.image.size
        case .Fit:
            return geometry.size
        case let .Scaled(scale):
            return CGSize(width: geometry.size.width * scale,
                          height: geometry.size.height * scale)
        }
    }
}

#Preview("Too Big") {
    ScrollableView(
        media: Media(
            id: "one",
            url: Bundle.main.url(forResource: "example", withExtension: "jpeg")!
        ),
        zoomMode: .constant(.ActualSize)
    )
    .frame(width: 400.0, height: 400.0)
}

#Preview("Just Right") {
    ScrollableView(
        media: Media(
            id: "one",
            url: Bundle.main.url(forResource: "longcat", withExtension: "jpg")!
        ),
        zoomMode: .constant(.Fit)
    )
    .frame(width: 400.0, height: 400.0)
}

#Preview("Too Small") {
    ScrollableView(
        media: Media(
            id: "one",
            url: Bundle.main.url(forResource: "example", withExtension: "jpeg")!
        ),
        zoomMode: .constant(.Scaled(0.5))
    )
    .frame(width: 400.0, height: 400.0)
}
