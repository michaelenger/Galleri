//
//  MediaView.swift
//  Galleri
//
//  Created by Michael Enger on 28/03/2023.
//

import SwiftUI

/// Shows the media (either an image or animated gif).
struct MediaView: View {
    let media: Media

    var body: some View {
        switch media.type {
        case .AnimatedImage:
            QLImage(url: media.url)
        case .StaticImage:
            Image(nsImage: media.image)
                .resizable()
                .scaledToFit()
        }
    }
}

#Preview("Animated GIF") {
    MediaView(media: Media(Bundle.main.url(forResource: "squid", withExtension: "gif")!))
}

#Preview("Static PNG") {
    MediaView(media: Media(Bundle.main.url(forResource: "grid", withExtension: "png")!))
}

#Preview("Two Static Images") {
    MediaView(media: Media(Bundle.main.url(forResource: "grid", withExtension: "png")!))
}
