//
//  DetailView.swift
//  Galleri
//
//  Created by Michael Enger on 18/03/2023.
//

import SwiftUI

let SCROLLBAR_SIZE: CGFloat = 15

/// The detail part of the content view - shows the current media.
struct DetailView: View {
    let media: Media?
    let isFullscreen: Bool
    let scalingMode: ScalingMode
    let rotationMode: RotationMode

    /// Get the frame that would fill a container with a content
    func getFillFrame(content: CGSize, container: CGSize) -> CGSize {
        let imgRatio = content.width / content.height
        let viewRatio = container.width / container.height

        if imgRatio > viewRatio {
            // Fit to height of visible frame
            let visibleHeight = container.height - SCROLLBAR_SIZE
            return CGSize(width: (visibleHeight / content.height) * content.width, height: visibleHeight)
        } else {
            // Fit to width of visible frame
            let visibleWidth = container.width - SCROLLBAR_SIZE
            return CGSize(width: visibleWidth, height: (visibleWidth / content.width) * content.height)
        }
    }

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

                    switch scalingMode {
                    case .ActualSize:
                        ScrollView([.horizontal, .vertical]) {
                            MediaView(media: media)
                        }
                            .rotationEffect(.degrees(rotation))
                            .frame(width: frame.width, height: frame.height)
                            .offset(x: xOffset, y: yOffset)
                    case .Dynamic:
                        DynamicZoomView(media: media)
                            .rotationEffect(.degrees(rotation))
                            .frame(width: frame.width, height: frame.height)
                            .offset(x: xOffset, y: yOffset)
                    case .Fit:
                        MediaView(media: media)
                            .rotationEffect(.degrees(rotation))
                            .frame(width: frame.width, height: frame.height)
                            .offset(x: xOffset, y: yOffset)
                    case .Fill:
                        let fillFrame = getFillFrame(content: media.image.size, container: frame)

                        ScrollView([.horizontal, .vertical]) {
                            MediaView(media: media)
                                .frame(width: fillFrame.width, height: fillFrame.height)
                        }
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

#Preview("Fit Original") {
    DetailView(
        media: Media(Bundle.main.url(forResource: "example", withExtension: "jpeg")!),
        isFullscreen: false,
        scalingMode: .Fit,
        rotationMode: .Original
    )
    .frame(width: 800.0, height: 600.0)
}

#Preview("Dynamic Rotated Right") {
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

#Preview("Fill Rotated Left") {
    DetailView(
        media: Media(Bundle.main.url(forResource: "longcat", withExtension: "jpg")!),
        isFullscreen: false,
        scalingMode: .Fill,
        rotationMode: .RotatedLeft
    )
    .frame(width: 400.0, height: 400.0)
}

#Preview("Actual Size Upside Down") {
    DetailView(
        media: Media(Bundle.main.url(forResource: "example", withExtension: "jpeg")!),
        isFullscreen: false,
        scalingMode: .ActualSize,
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
