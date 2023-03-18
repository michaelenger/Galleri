//
//  MediaView.swift
//  Galleri
//
//  Created by Michael Enger on 18/03/2023.
//

import SwiftUI

struct MediaView: View {
    var image: NSImage

    init(filePath: String) {
        // TODO handle other media types
        let imageUrl = URL(fileURLWithPath: filePath)
        self.image = NSImage(contentsOf: imageUrl)!
    }

    var body: some View {
        Image(nsImage: self.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

struct MediaView_Previews: PreviewProvider {
    static var previews: some View {
        MediaView(filePath: "/Users/michaelenger/Downloads/DDfX1SX.jpeg")
            .frame(width: 200.0, height: 200.0)
    }
}
