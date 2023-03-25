//
//  GalleryImageView.swift
//  Galleri
//
//  Created by Michael Enger on 22/03/2023.
//

import SwiftUI

/// An image view that scales the image to the view and allows you to zoom/pan around using the mouse.
struct GalleryImageView: View {
    @EnvironmentObject var dataStore: DataStore
    @State var mousePosition = CGPoint(x: 0.5, y: 0.5)
    @State var isMouseOver = false
    @State var zoomScale: CGFloat = 1.5
    @State var isZooming = false
    @State var eventMonitor: Any? = nil

    var media: Media

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                if isZooming {
                    let scale = imageFitScale(frameSize: geometry.size) * zoomScale
                    let offset = imageOffset(
                        frameSize: geometry.size,
                        imageSize: CGSize(
                            width: media.image.size.width * scale,
                            height: media.image.size.height * scale))

                    Image(nsImage: media.image)
                        .resizable()
                        .frame(width: media.image.size.width * scale,
                               height: media.image.size.height * scale)
                        .offset(x: offset.x, y: offset.y)
                } else {
                    Image(nsImage: media.image)
                        .resizable()
                        .scaledToFit()
                }
//                Text("\(mousePosition.x) x \(mousePosition.y)")
//                    .foregroundColor(.black)
//                    .background(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onHover { over in
                isMouseOver = over
            }
            .onAppear(perform: {
                eventMonitor = NSEvent.addLocalMonitorForEvents(matching: [
                    .leftMouseDown,
                    .rightMouseDown,
                    .otherMouseDown,
                    .scrollWheel,
                    .mouseMoved
                ]) { event in
                    if !isMouseOver {
                        return event  // ignore all mouse events if not over the view
                    }

                    switch event.type {
                    case .leftMouseDown:
                        goToNext()
                    case .rightMouseDown:
                        goToPrevious()
                    case .otherMouseDown:
                        toggleZoom()
                    case .scrollWheel:
                        changeScale(step: event.deltaY)
                    case .mouseMoved:
                        updateMousePosition(locationInWindow: event.locationInWindow, geometry: geometry)
                    default:
                        logger.error("Unhandled event type: \(event.type.rawValue)")
                    }

                    return event
                }
            })
            .onDisappear(perform: {
                NSCursor.unhide()  // just in case

                if eventMonitor != nil {
                    NSEvent.removeMonitor(eventMonitor!)
                    eventMonitor = nil
                }
            })
        }
    }
}

extension GalleryImageView {
    /// Change the scale based on a step variable.
    func changeScale(step: CGFloat) {
        if !isZooming {
            if step < 0 {
                return  // zooming out when not in zoom mode is ignored
            }

            toggleZoom()
            zoomScale = 1.0
        }

        zoomScale = clamp(zoomScale + (SCALE_INTERVAL * step), min: SCALE_MIN, max: SCALE_MAX)

        if zoomScale == 1 && isZooming {
            toggleZoom()  // it's effectively off
        }
    }

    /// Go to the next media.
    func goToNext() {
        dataStore.goToNext()
    }

    /// Go to the previous media.
    func goToPrevious() {
        dataStore.goToPrevious()
    }

    /// Scale for filling the frame with the image.
    func imageFillScale(frameSize: CGSize) -> CGFloat {
        let wRatio = frameSize.width / media.image.size.width
        let hRatio = frameSize.height / media.image.size.height

        return max(wRatio, hRatio)
    }

    /// Scale for fitting the image in the frame.
    func imageFitScale(frameSize: CGSize) -> CGFloat {
        let wRatio = frameSize.width / media.image.size.width
        let hRatio = frameSize.height / media.image.size.height

        if media.image.size.height * wRatio <= frameSize.height {
            return wRatio
        } else {
            return hRatio
        }
    }

    /// Get the image offset based on the frame, scale, and mouse positions.
    func imageOffset(frameSize: CGSize, imageSize: CGSize) -> CGPoint {
        let xOffset = imageSize.width > frameSize.width
            ? -(imageSize.width - frameSize.width) * mousePosition.x
            : 0
        let yOffset = imageSize.height > frameSize.height
            ? -(imageSize.height - frameSize.height) * mousePosition.y
            : 0

        return CGPoint(x: xOffset, y: yOffset)
    }

    /// Toggle the zoom.
    func toggleZoom() {
        isZooming.toggle()

        if isZooming {
            NSCursor.hide()
        } else {
            NSCursor.unhide()
        }
    }

    /// Update the mouse position based on a mouse event and geometry.
    func updateMousePosition(locationInWindow: NSPoint, geometry: GeometryProxy) {
        let frame = geometry.frame(in: .global)
        var x = locationInWindow.x - frame.origin.x
        var y = frame.size.height - locationInWindow.y  // this only works on the bottom of the window

        if x < 0 || x > frame.width || y < 0 || y > frame.height {
            return  // we're outside the frame, but the mouse hover event wasn't caught for some reason
        }

        // Convert to 0-1 range and "pad" it
        x = clamp(
            ((x / frame.width * 4) - 1) / 2,
            min: 0, max: 1)
        y = clamp(
            ((y / frame.height * 4) - 1) / 2,
            min: 0, max: 1)

        mousePosition = CGPoint(
            x: x,
            y: y
        )
    }
}

struct GalleryImageView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryImageView(
            media: Media(Bundle.main.url(forResource: "grid", withExtension: "png")!)
        )
        .frame(width: 600.0, height: 700.0)
    }
}
