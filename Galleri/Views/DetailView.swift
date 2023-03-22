//
//  DetailView.swift
//  Galleri
//
//  Created by Michael Enger on 18/03/2023.
//

import SwiftUI

struct DetailView: View {
    @Binding var media: Media?
    @Binding var isFullscreen: Bool

    var body: some View {
        VStack {
            if media != nil {
                if isFullscreen {
                    GalleryImageView(media: media!)
                } else {
                    ScrollableImageView(media: media!)
                }
            } else {
                Image(systemName: "photo.stack")
                    .imageScale(.large)
                    .foregroundColor(.gray)
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment:.center)
        .background(isFullscreen ? .black : .clear)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(
            media: .constant(Media(URL(fileURLWithPath: "/Users/michaelenger/Downloads/DDfX1SX.jpeg"))),
            isFullscreen: .constant(false)
        )
        .frame(width: 300.0, height: 300.0)

        DetailView(
            media: .constant(nil),
            isFullscreen: .constant(false)
        )
        .frame(width: 300.0, height: 300.0)
    }
}
