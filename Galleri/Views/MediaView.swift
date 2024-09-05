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

struct MediaView_Previews: PreviewProvider {
    static var previews: some View {
        MediaView(media: Media(Bundle.main.url(forResource: "squid", withExtension: "gif")!))

        MediaView(media: Media(Bundle.main.url(forResource: "grid", withExtension: "png")!))
    }
}
