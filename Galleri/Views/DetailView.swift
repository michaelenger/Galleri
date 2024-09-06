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
    let rotationMode: RotationMode

    var body: some View {
        let rotation: Double = switch rotationMode {
        case .Original:
            0
        case .RotatedRight:
            90
        case .RotatedLeft:
            -90
        case .UpsideDown:
            180
        }

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
        .rotationEffect(.degrees(rotation))
    }
}

#Preview("Original Rotation") {
    DetailView(
        media: Media(Bundle.main.url(forResource: "example", withExtension: "jpeg")!),
        isFullscreen: false,
        scalingMode: .FitWidth,
        rotationMode: .Original
    )
    .frame(width: 300.0, height: 300.0)
}

#Preview("Rotated Right") {
    DetailView(
        media: Media(Bundle.main.url(forResource: "example", withExtension: "jpeg")!),
        isFullscreen: false,
        scalingMode: .FitHeight,
        rotationMode: .RotatedRight
    )
    .frame(width: 300.0, height: 300.0)
}

#Preview("Rotated Left") {
    DetailView(
        media: Media(Bundle.main.url(forResource: "example", withExtension: "jpeg")!),
        isFullscreen: false,
        scalingMode: .FitHeight,
        rotationMode: .RotatedLeft
    )
    .frame(width: 300.0, height: 300.0)
}

#Preview("Upside Down") {
    DetailView(
        media: Media(Bundle.main.url(forResource: "example", withExtension: "jpeg")!),
        isFullscreen: false,
        scalingMode: .FitHeight,
        rotationMode: .UpsideDown
    )
    .frame(width: 300.0, height: 300.0)
}

#Preview("No Media") {
    DetailView(
        media: nil,
        isFullscreen: false,
        scalingMode: .Dynamic,
        rotationMode: .Original
    )
    .frame(width: 300.0, height: 300.0)
}
