//
//  GalleryImageView.swift
//  Galleri
//
//  Created by Michael Enger on 22/03/2023.
//

import SwiftUI

/// Contains the input monitors for the GalleryImageView.
class GalleryImageViewMonitors {
    private var monitors: [Any] = []

    /// Append a monitor to the list.
    func append(_ monitor: Any?) {
        if monitor != nil {
            monitors.append(monitor!)
        }
    }

    /// Clear all the monitors, unregistering them in the process.
    func clear() {
        for monitor in monitors {
            NSEvent.removeMonitor(monitor)
        }

        monitors.removeAll()
    }
}

/// An image view that scales the image to the view and allows you to zoom/pan around using the mouse.
struct GalleryImageView: View {
    @State var mousePosition = CGPoint(x: 0.5, y: 0.5)
    @State var isMouseOver = false
    @State var scale: CGFloat = 1.5
    @State var isZooming = false

    var media: Media
    var monitors = GalleryImageViewMonitors()

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
                monitors.append(NSEvent.addLocalMonitorForEvents(matching: [.leftMouseDown]) { event in
                    toggleZoom()

                    return event
                })

                monitors.append(NSEvent.addLocalMonitorForEvents(matching: [.scrollWheel]) { event in
                    changeScale(step: event.deltaY)

                    return event
                })

                monitors.append(NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) { event in
                    updateMousePosition(locationInWindow: event.locationInWindow, geometry: geometry)
                    return event
                })
            })
            .onDisappear(perform: {
                NSCursor.unhide()  // just in case
                monitors.clear()
            })
        }
    }
}

extension GalleryImageView {
    /// Change the scale based on a step variable.
    func changeScale(step: CGFloat) {
        scale = clamp(scale + SCALE_INTERVAL * step, min: SCALE_MIN, max: SCALE_MAX)
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
        isZooming = !isZooming

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
            media: Media(URL(fileURLWithPath: "/Users/michaelenger/Desktop/grid.png"))
        )
        .frame(width: 600.0, height: 700.0)
    }
}
