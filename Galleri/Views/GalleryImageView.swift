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
    @State var scale: CGFloat = 1.5
    @State var isZooming = false
    @State var eventMonitor: Any? = nil

    var media: Media

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                if isZooming {
                    let (imageScale, xOffset, yOffset) = imageScaleOffset(geometry: geometry)

                    Image(nsImage: media.image)
                        .resizable()
                        .frame(width: media.image.size.width * imageScale,
                               height: media.image.size.height * imageScale)
                        .offset(x: xOffset, y: yOffset)
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
                        print("Unhandled event type: \(event.type)")
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
        if (!isZooming) {
            return  // don't change scale unless we can see the effect
        }

        scale = clamp(scale + SCALE_INTERVAL * step, min: SCALE_MIN, max: SCALE_MAX)
    }

    /// Go to the next media.
    func goToNext() {
        dataStore.goToNext()
    }

    /// Go to the previous media.
    func goToPrevious() {
        dataStore.goToPrevious()
    }

    /// Get the image scale and offsets based on the given geometry.
    func imageScaleOffset(geometry: GeometryProxy) -> (CGFloat, CGFloat, CGFloat) {
        let wRatio = geometry.size.width / media.image.size.width * scale
        let hRatio = geometry.size.height / media.image.size.height * scale

        let imageScale = max(wRatio, hRatio)
        let xOffset = -((media.image.size.width * imageScale) - geometry.size.width) * mousePosition.x
        let yOffset = -((media.image.size.height * imageScale) - geometry.size.height) * mousePosition.y

        return (imageScale, xOffset, yOffset)
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
        if !isMouseOver {
            return  // nothing to do here
        }

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
