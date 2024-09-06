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
    @State private var isFullscreen = false

    var willEnterFullScreen = NotificationCenter.default.publisher(for: NSWindow.willEnterFullScreenNotification)
    var willExitFullScreen = NotificationCenter.default.publisher(for: NSWindow.willExitFullScreenNotification)

    var body: some View {
        @Bindable var dataStore = dataStore

        NavigationSplitView(columnVisibility: $columnVisibility) {
            SidebarView(selection: $dataStore.selectedMediaID)
        } detail: {
            DetailView(
                media: $dataStore[dataStore.selectedMediaID],
                isFullscreen: $isFullscreen,
                zoomMode: $dataStore.zoomMode
            )
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    HStack {
                        Button(action: {
                            dataStore.goToPrevious()
                        }) {
                            Label("Previous", systemImage: "arrow.left")
                        }
                        .disabled(!dataStore.hasMedia)
                        Button(action: {
                            dataStore.goToNext()
                        }) {
                            Label("Next", systemImage: "arrow.right")
                        }
                        .disabled(!dataStore.hasMedia)
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    HStack {
                        Menu {
                            Picker("Zoom Mode", selection: $dataStore.zoomMode) {
                                Text("Dynamic Zoom").tag(ZoomMode.Dynamic)
                                Text("Actual Size").tag(ZoomMode.ActualSize)
                                Text("Fit Width").tag(ZoomMode.FitWidth)
                                Text("Fit Height").tag(ZoomMode.FitHeight)
                            }
                            .pickerStyle(.inline)
                            .labelsHidden()
                        } label: {
                            Label("Zoom Mode", systemImage: "square.arrowtriangle.4.outward")
                        }
                    }
                }
            }
            .navigationTitle(dataStore[dataStore.selectedMediaID]?.filename ?? "")
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

#Preview {
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
