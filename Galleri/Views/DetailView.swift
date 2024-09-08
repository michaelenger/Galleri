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
        GeometryReader { geometry in
            VStack {
                if let media = media {
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

                    let isRotated = rotationMode == .RotatedLeft || rotationMode == .RotatedRight

                    let frame = isRotated
                        ? CGSize(width: geometry.size.height, height: geometry.size.width)
                        : geometry.size

                    let xOffset: CGFloat = isRotated && geometry.size.height > geometry.size.width
                        ? -(geometry.size.height - geometry.size.width) / 2
                        : 0
                    let yOffset: CGFloat = isRotated && geometry.size.width > geometry.size.height
                        ? -(geometry.size.width - geometry.size.height) / 2
                        : 0

                    if scalingMode == .Dynamic {
                        DynamicZoomView(media: media)
                            .rotationEffect(.degrees(rotation))
                            .frame(width: frame.width, height: frame.height)
                            .offset(x: xOffset, y: yOffset)
                    } else {
                        ScrollableView(media: media, scalingMode: scalingMode)
                            .rotationEffect(.degrees(rotation))
                            .frame(width: frame.width, height: frame.height)
                            .offset(x: xOffset, y: yOffset)
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
}

#Preview("Original Rotation") {
    DetailView(
        media: Media(Bundle.main.url(forResource: "example", withExtension: "jpeg")!),
        isFullscreen: false,
        scalingMode: .FitWidth,
        rotationMode: .Original
    )
    .frame(width: 800.0, height: 600.0)
}

#Preview("Rotated Right") {
    DetailView(
        media: Media(Bundle.main.url(forResource: "longcat", withExtension: "jpg")!),
        isFullscreen: false,
        scalingMode: .Dynamic,
        rotationMode: .RotatedRight
    )
    .frame(width: 800.0, height: 600.0)
    .environment({ () -> DataStore in
        let envObj = DataStore()
        envObj.loadMedia(from: [
            Bundle.main.url(forResource: "longcat", withExtension: "jpg")!,
        ])
        return envObj
    }() )
}

#Preview("Rotated Left") {
    DetailView(
        media: Media(Bundle.main.url(forResource: "grid", withExtension: "png")!),
        isFullscreen: false,
        scalingMode: .FitHeight,
        rotationMode: .RotatedLeft
    )
    .frame(width: 800.0, height: 600.0)
    .environment({ () -> DataStore in
        let envObj = DataStore()
        envObj.loadMedia(from: [
            Bundle.main.url(forResource: "grid", withExtension: "png")!,
        ])
        return envObj
    }() )
}

#Preview("Upside Down") {
    DetailView(
        media: Media(Bundle.main.url(forResource: "example", withExtension: "jpeg")!),
        isFullscreen: false,
        scalingMode: .FitHeight,
        rotationMode: .UpsideDown
    )
    .frame(width: 800.0, height: 600.0)
}

#Preview("No Media") {
    DetailView(
        media: nil,
        isFullscreen: false,
        scalingMode: .Dynamic,
        rotationMode: .Original
    )
    .frame(width: 800.0, height: 600.0)
}
