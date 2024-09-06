//
//  ViewCommands.swift
//  Galleri
//
//  Created by Michael Enger on 19/03/2023.
//

import SwiftUI

/// Contains the commands for the View menu.
struct ViewCommands: Commands {
    var dataStore: DataStore

    @AppStorage("sortBy") var sortBy = DEFAULT_SORT_BY

    /// Side-effects for when the soryBy setting changes.
    func sortByChanged(to value: SortOrder) {
        dataStore.sortMediaItems()
    }

    var body: some Commands {
        let zoomModeBinding = Binding<ZoomMode>(
            get: { dataStore.zoomMode },
            set: { dataStore.zoomMode = $0 })

        CommandGroup(after: .sidebar) {
            Section {
                Picker("Zoom Mode", selection: zoomModeBinding) {
                    Text("Dynamic").tag(ZoomMode.Dynamic)
                    Text("Actual Size").tag(ZoomMode.ActualSize)
                    Text("Fit Width").tag(ZoomMode.FitWidth)
                    Text("Fit Height").tag(ZoomMode.FitHeight)
                }
                .pickerStyle(.inline)
                Picker("Sort By", selection: $sortBy.onChange(sortByChanged)) {
                    Text("Name").tag(SortOrder.name)
                    Text("Path").tag(SortOrder.path)
                    Text("Date").tag(SortOrder.date)
                    Text("Size").tag(SortOrder.size)
                    Text("Kind").tag(SortOrder.kind)
                    Text("Random").tag(SortOrder.random)
                }
            }
        }
    }
}
