//
//  ViewCommands.swift
//  Galleri
//
//  Created by Michael Enger on 19/03/2023.
//

import SwiftUI

/// Contains the commands for the View menu.
struct ViewCommands: Commands {
    @ObservedObject var dataStore: DataStore

    @AppStorage("sortBy") var sortBy = DefaultSettings.sortBy

    /// Side-effects for when the soryBy setting changes.
    func sortByChanged(to value: SortOrder) {
        dataStore.sortMediaItems()
    }

    var body: some Commands {
        CommandGroup(after: .sidebar) {
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
