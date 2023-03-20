//
//  ImageView.swift
//  Galleri
//
//  Created by Michael Enger on 18/03/2023.
//

import SwiftUI

struct ImageView: View {
    var media: Media

    var body: some View {
        Image(nsImage: self.media.image!)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(media: Media(URL(fileURLWithPath: "/Users/michaelenger/Downloads/DDfX1SX.jpeg")))
            .frame(width: 200.0, height: 200.0)
    }
}
