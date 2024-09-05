//
//  ScrollableImageView.swift
//  Galleri
//
//  Created by Michael Enger on 18/03/2023.
//

import SwiftUI

/// An image view that displays the image and allows you to scroll, if necessary.
struct ScrollableImageView: View {
    var media: Media

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

extension ScrollableImageView {
    /// Get the desired frame size based on the image's zoom mode.
    func desiredFrameSize(geometry: GeometryProxy) -> CGSize {
        switch media.zoomMode {
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

struct ScrollableImageView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollableImageView(
            media: Media(
                id: "one",
                url: Bundle.main.url(forResource: "example", withExtension: "jpeg")!,
                zoomMode: .ActualSize)
        )
        .frame(width: 400.0, height: 400.0)

        ScrollableImageView(
            media: Media(
                id: "one",
                url: Bundle.main.url(forResource: "example", withExtension: "jpeg")!,
                zoomMode: .Fit)
        )
        .frame(width: 400.0, height: 400.0)

        ScrollableImageView(
            media: Media(
                id: "one",
                url: Bundle.main.url(forResource: "example", withExtension: "jpeg")!,
                zoomMode: .Scaled(0.5))
        )
        .frame(width: 400.0, height: 400.0)
    }
}

