//
//  ContentView.swift
//  Galleri
//
//  Created by Michael Enger on 19/03/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var columnVisibility = NavigationSplitViewVisibility.automatic
    @State private var isFullscreen = false

    var willEnterFullScreen = NotificationCenter.default.publisher(for: NSWindow.willEnterFullScreenNotification)
    var willExitFullScreen = NotificationCenter.default.publisher(for: NSWindow.willExitFullScreenNotification)

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            SidebarView(selection: $dataStore.selectedMediaID)
        } detail: {
            DetailView(
                media: $dataStore[dataStore.selectedMediaID],
                isFullscreen: $isFullscreen
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject({ () -> DataStore in
                let envObj = DataStore()
                envObj.loadMedia(from: [
                    URL(fileURLWithPath: "/Users/michaelenger/Downloads/DDfX1SX.jpeg"),
                    URL(fileURLWithPath: "/Users/michaelenger/Downloads/dikbut.png"),
                ])
                return envObj
            }() )
    }
}
