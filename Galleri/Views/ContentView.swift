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
                Button(action: {
                    dataStore.zoomIn()
                }) {
                    Label("Zoom In", systemImage: "plus.magnifyingglass")
                }
                .disabled(dataStore.selectedMediaID == nil)
                Button(action: {
                    dataStore.zoomOut()
                }) {
                    Label("Zoom Out", systemImage: "minus.magnifyingglass")
                }
                .disabled(dataStore.selectedMediaID == nil)
                Button(action: {
                    dataStore.zoomToFit()
                }) {
                    Label("Zoom to Fit", systemImage: "arrow.up.left.and.down.right.and.arrow.up.right.and.down.left")
                }
                .disabled(dataStore.selectedMediaID == nil)
            }
            .navigationTitle("")
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
