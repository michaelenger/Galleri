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
                scalingMode: $dataStore.scalingMode
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
                        Menu {
                            Picker("Scaling Mode", selection: $dataStore.scalingMode) {
                                Text("Dynamic").tag(ScalingMode.Dynamic)
                                Text("Actual Size").tag(ScalingMode.ActualSize)
                                Text("Fit Width").tag(ScalingMode.FitWidth)
                                Text("Fit Height").tag(ScalingMode.FitHeight)
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
