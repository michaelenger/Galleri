//
//  ScrollableView.swift
//  Galleri
//
//  Created by Michael Enger on 18/03/2023.
//

import SwiftUI

let SCROLLBAR_SIZE: CGFloat = 15

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
        case .FitHeight:
            var width = media.image.size.width * (geometry.size.height / media.image.size.height)
            var height = geometry.size.height
            if (width > geometry.size.width) {  // we'll see a scrollbar
                width = width - SCROLLBAR_SIZE
                height = height - SCROLLBAR_SIZE
            }

            return CGSize(width: width,
                          height: height)
        case .FitWidth:
            var width = geometry.size.width
            var height = media.image.size.height * (geometry.size.width / media.image.size.width)
            if (height > geometry.size.height) {  // we'll see a scrollbar
                width = width - SCROLLBAR_SIZE
                height = height - (SCROLLBAR_SIZE * 2)
            }

            return CGSize(width: width,
                          height: height)
        case let .Scaled(scale):
            return CGSize(width: geometry.size.width * scale,
                          height: geometry.size.height * scale)
        }
    }
}

#Preview("Actual Size") {
    ScrollableView(
        media: Media(
            id: "one",
            url: Bundle.main.url(forResource: "example", withExtension: "jpeg")!
        ),
        zoomMode: .constant(.ActualSize)
    )
    .frame(width: 400.0, height: 400.0)
}

#Preview("Fit") {
    ScrollableView(
        media: Media(
            id: "one",
            url: Bundle.main.url(forResource: "example", withExtension: "jpeg")!
        ),
        zoomMode: .constant(.Fit)
    )
    .frame(width: 400.0, height: 400.0)
}

#Preview("Fit Height") {
    ScrollableView(
        media: Media(
            id: "one",
            url: Bundle.main.url(forResource: "example", withExtension: "jpeg")!
        ),
        zoomMode: .constant(.FitHeight)
    )
    .frame(width: 400.0, height: 400.0)
}

#Preview("Fit Width") {
    ScrollableView(
        media: Media(
            id: "one",
            url: Bundle.main.url(forResource: "longcat", withExtension: "jpg")!
        ),
        zoomMode: .constant(.FitWidth)
    )
    .frame(width: 400.0, height: 400.0)
}

#Preview("Scaled") {
    ScrollableView(
        media: Media(
            id: "one",
            url: Bundle.main.url(forResource: "example", withExtension: "jpeg")!
        ),
        zoomMode: .constant(.Scaled(0.5))
    )
    .frame(width: 400.0, height: 400.0)
}
