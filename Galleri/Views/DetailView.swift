//
//  DetailView.swift
//  Galleri
//
//  Created by Michael Enger on 18/03/2023.
//

import SwiftUI

/// The detail part of the content view - shows the current media.
struct DetailView: View {
    @Binding var media: Media?
    @Binding var isFullscreen: Bool
    @Binding var scalingMode: ScalingMode

    var body: some View {
        VStack {
            if media != nil {
                if scalingMode == .Dynamic {
                    DynamicZoomView(media: media!)
                } else {
                    ScrollableView(media: media!, scalingMode: $scalingMode)
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
        media: .constant(Media(Bundle.main.url(forResource: "example", withExtension: "jpeg")!)),
        isFullscreen: .constant(false),
        scalingMode: .constant(.Dynamic)
    )
    .frame(width: 300.0, height: 300.0)
}

#Preview("No Media") {
    DetailView(
        media: .constant(nil),
        isFullscreen: .constant(false),
        scalingMode: .constant(.Dynamic)
    )
    .frame(width: 300.0, height: 300.0)
}
