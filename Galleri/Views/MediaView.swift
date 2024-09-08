//
//  MediaView.swift
//  Galleri
//
//  Created by Michael Enger on 28/03/2023.
//

import SwiftUI

/// Shows the media (either an image or animated gif).
struct MediaView: View {
    let media: ViewableMedia

    var body: some View {
        HStack(spacing: 0) {
            ForEach(media.mediaItems) { item in
                switch item.type {
                case .AnimatedImage:
                    QLImage(url: item.url)
                case .StaticImage:
                    Image(nsImage: item.image)
                        .resizable()
                        .scaledToFit()
                }
            }
        }
    }
}

#Preview("Animated GIF") {
    MediaView(media: ViewableMedia(Media(Bundle.main.url(forResource: "squid", withExtension: "gif")!)))
}

#Preview("Static PNG") {
    MediaView(media: ViewableMedia(Media(Bundle.main.url(forResource: "grid", withExtension: "png")!)))
}

#Preview("Two Static Images") {
    MediaView(media: ViewableMedia(
        Media(Bundle.main.url(forResource: "grid", withExtension: "png")!),
        Media(Bundle.main.url(forResource: "grid", withExtension: "png")!)))
}

#Preview("Combined Images") {
    MediaView(media: ViewableMedia(
        Media(Bundle.main.url(forResource: "squid", withExtension: "gif")!),
        Media(Bundle.main.url(forResource: "grid", withExtension: "png")!)))
}
