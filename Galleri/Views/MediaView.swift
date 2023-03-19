//
//  MediaView.swift
//  Galleri
//
//  Created by Michael Enger on 18/03/2023.
//

import SwiftUI

struct MediaView: View {
    var media: Media

    var body: some View {
        Image(nsImage: self.media.image!)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

struct MediaView_Previews: PreviewProvider {
    static var previews: some View {
        MediaView(media: Media(URL(fileURLWithPath: "/Users/michaelenger/Downloads/DDfX1SX.jpeg")))
            .frame(width: 200.0, height: 200.0)
    }
}
