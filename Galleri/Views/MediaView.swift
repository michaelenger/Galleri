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
        if media.url.isAnimatedImage {
            QLImage(url: media.url)
        } else {
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
