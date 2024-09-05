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

    @AppStorage("sortBy") var sortBy = DefaultSettings.sortBy

    /// Side-effects for when the soryBy setting changes.
    func sortByChanged(to value: SortOrder) {
        dataStore.sortMediaItems()
    }

    var body: some Commands {
        CommandGroup(after: .sidebar) {
            Section {
                Button("Actual Size") {
                    dataStore.setZoomMode(.ActualSize)
                }
                .disabled(!dataStore.hasMedia)
                .keyboardShortcut("0")

                Button("Fit Height") {
                    dataStore.setZoomMode(.FitHeight)
                }
                .disabled(!dataStore.hasMedia)
                .keyboardShortcut("8")

                Button("Fit Width") {
                    dataStore.setZoomMode(.FitWidth)
                }
                .disabled(!dataStore.hasMedia)
                .keyboardShortcut("8")

                Button("Dynamic") {
                    dataStore.setZoomMode(.Dynamic)
                }
                .disabled(!dataStore.hasMedia)
                .keyboardShortcut("9")
            }
            Section {
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
