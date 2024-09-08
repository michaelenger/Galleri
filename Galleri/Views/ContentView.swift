//
//  ContentView.swift
//  Galleri
//
//  Created by Michael Enger on 19/03/2023.
//

import SwiftUI

/// The main view which shows a toggle-able sidebar and the actual media.
struct ContentView: View {
    @Environment(DataStore.self) private var dataStore
    @State private var columnVisibility = NavigationSplitViewVisibility.automatic
    @State private var eventMonitor: Any? = nil
    @State private var isFullscreen = false
    @State private var isMouseOver = false

    var willEnterFullScreen = NotificationCenter.default.publisher(for: NSWindow.willEnterFullScreenNotification)
    var willExitFullScreen = NotificationCenter.default.publisher(for: NSWindow.willExitFullScreenNotification)

    var body: some View {
        @Bindable var dataStore = dataStore

        NavigationSplitView(columnVisibility: $columnVisibility) {
            SidebarView(selection: $dataStore.selectedMediaID)
        } detail: {
            DetailView(
                media: dataStore.currentMediaItem,
                isFullscreen: isFullscreen,
                scalingMode: dataStore.scalingMode,
                rotationMode: dataStore.rotationMode
            )
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    HStack {
                        Button(action: {
                            dataStore.goToPrevious()
                        }) {
                            Label("Previous", systemImage: "arrow.left")
                        }
                        .help("Previous")
                        .disabled(!dataStore.hasMedia)
                        Button(action: {
                            dataStore.goToNext()
                        }) {
                            Label("Next", systemImage: "arrow.right")
                        }
                        .help("Next")
                        .disabled(!dataStore.hasMedia)
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    HStack {
                        Button(action: {
                            dataStore.rotateLeft()
                        }) {
                            Label("Rotate Left", systemImage: "rotate.left")
                        }
                        .help("Rotate left")
                        .keyboardShortcut("r")
                        .disabled(!dataStore.hasMedia)

                        Menu {
                            Picker("View Mode", selection: $dataStore.viewMode) {
                                Text("Single").tag(ViewMode.Single)
                                Text("Double Left-to-Right").tag(ViewMode.DoubleLTR)
                                Text("Double Right-to-Left").tag(ViewMode.DoubleRTL)
                            }
                            .pickerStyle(.inline)
                            .labelsHidden()
                        } label: {
                            Label("View Mode", systemImage: "rectangle.split.2x1")
                        }
                        .help("Choose view mode")
                        
                        Menu {
                            Picker("Scaling Mode", selection: $dataStore.scalingMode) {
                                Text("Dynamic").tag(ScalingMode.Dynamic)
                                Text("Actual Size").tag(ScalingMode.ActualSize)
                                Text("Fit to View").tag(ScalingMode.Fit)
                                Text("Fill View").tag(ScalingMode.Fill)
                            }
                            .pickerStyle(.inline)
                            .labelsHidden()
                        } label: {
                            Label("Scaling Mode", systemImage: "square.arrowtriangle.4.outward")
                        }
                        .help("Choose scaling mode")
                    }
                }
            }
            .navigationTitle(dataStore[dataStore.selectedMediaID]?.filename ?? "")
            .onHover { over in
                isMouseOver = over
            }
            .onAppear(perform: {
                eventMonitor = NSEvent.addLocalMonitorForEvents(matching: [
                    .leftMouseDown,
                    .rightMouseDown
                ]) { event in
                    if !isMouseOver || !isFullscreen {
                        return event  // ignore all mouse events if not over the view
                    }

                    switch event.type {
                    case .leftMouseDown:
                        dataStore.goToNext()
                    case .rightMouseDown:
                        dataStore.goToPrevious()
                    default:
                        logger.error("Unhandled event type: \(event.type.rawValue)")
                    }

                    return event
                }
            })
        }
        .toolbar(isFullscreen ? .hidden : .visible)
        .addCustomHotkeys([
            HotkeyCombination(keyBase: [], key: .kVK_LeftArrow ) {
                dataStore.goToPrevious()
            },
            HotkeyCombination(keyBase: [], key: .kVK_RightArrow) {
                dataStore.goToNext()
            },
            HotkeyCombination(keyBase: [], key: .kVK_Space) {
                dataStore.goToNext()
            }
        ])
        .onReceive(willEnterFullScreen, perform: { _ in
            isFullscreen = true
            columnVisibility = .detailOnly
        })
        .onReceive(willExitFullScreen, perform: { _ in
            isFullscreen = false
            columnVisibility = .automatic
        })
    }
}

#Preview("Single View") {
    ContentView()
        .environment({ () -> DataStore in
            let envObj = DataStore()
            envObj.loadMedia(from: [
                Bundle.main.url(forResource: "example", withExtension: "jpeg")!,
                Bundle.main.url(forResource: "grid", withExtension: "png")!,
            ])
            return envObj
        }() )
}

#Preview("Double View") {
    ContentView()
        .environment({ () -> DataStore in
            let envObj = DataStore()
            envObj.loadMedia(from: [
                Bundle.main.url(forResource: "example", withExtension: "jpeg")!,
                Bundle.main.url(forResource: "grid", withExtension: "png")!,
            ])
            envObj.viewMode = .DoubleLTR
            return envObj
        }() )
}
