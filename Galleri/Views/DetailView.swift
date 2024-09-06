//
//  DetailView.swift
//  Galleri
//
//  Created by Michael Enger on 18/03/2023.
//

import SwiftUI

/// The detail part of the content view - shows the current media.
struct DetailView: View {
    let media: Media?
    let isFullscreen: Bool
    let scalingMode: ScalingMode

    var body: some View {
        VStack {
            if media != nil {
                if scalingMode == .Dynamic {
                    DynamicZoomView(media: media!)
                } else {
                    ScrollableView(media: media!, scalingMode: scalingMode)
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

#Preview("With Media") {
    DetailView(
        media: Media(Bundle.main.url(forResource: "example", withExtension: "jpeg")!),
        isFullscreen: false,
        scalingMode: .Dynamic
    )
    .frame(width: 300.0, height: 300.0)
}

#Preview("No Media") {
    DetailView(
        media: nil,
        isFullscreen: false,
        scalingMode: .Dynamic
    )
    .frame(width: 300.0, height: 300.0)
}
