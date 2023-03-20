//
//  ImageView.swift
//  Galleri
//
//  Created by Michael Enger on 18/03/2023.
//

import SwiftUI

struct ImageView: View {
    @ObservedObject var media: Media
    let parentFrameSize: CGSize    

    var body: some View {
        let desiredFrameSize = desiredFrameSize()

        if desiredFrameSize.width != 0 && desiredFrameSize.height != 0 {
            Image(nsImage: self.media.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: desiredFrameSize.width, height: desiredFrameSize.height)
        } else {
            Image(nsImage: self.media.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: parentFrameSize.width, height: parentFrameSize.height)
        }
    }
}

extension ImageView {
    func desiredFrameSize() -> CGSize {
        switch media.zoomMode {
        case .ActualSize:
            return media.image.size
        case .Fit:
            return CGSize(width: 0, height: 0)
        case let .Scaled(scale):
            return CGSize(width: parentFrameSize.width * scale,
                          height: parentFrameSize.height * scale)
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            GeometryReader { geometry in
                ImageView(
                    media: Media(
                        id: "one",
                        url: URL(fileURLWithPath: "/Users/michaelenger/Downloads/DDfX1SX.jpeg"),
                        zoomMode: .ActualSize),
                    parentFrameSize: geometry.size
                )
            }
        }
        .frame(width: 400.0, height: 400.0)

        VStack {
            GeometryReader { geometry in
                ImageView(
                    media: Media(
                        id: "one",
                        url: URL(fileURLWithPath: "/Users/michaelenger/Downloads/DDfX1SX.jpeg"),
                        zoomMode: .Fit),
                    parentFrameSize: geometry.size
                )
            }
        }
        .frame(width: 400.0, height: 400.0)

        VStack {
            GeometryReader { geometry in
                ImageView(
                    media: Media(
                        id: "one",
                        url: URL(fileURLWithPath: "/Users/michaelenger/Downloads/DDfX1SX.jpeg"),
                        zoomMode: .Scaled(0.5)),
                    parentFrameSize: geometry.size
                )
            }
        }
        .frame(width: 400.0, height: 400.0)
    }
}
