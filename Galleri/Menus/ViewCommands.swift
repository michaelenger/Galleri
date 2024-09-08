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
        let rotationModeBinding = Binding<RotationMode>(
            get: { dataStore.rotationMode },
            set: { dataStore.rotationMode = $0 })
        let scalingModeBinding = Binding<ScalingMode>(
            get: { dataStore.scalingMode },
            set: { dataStore.scalingMode = $0 })

        CommandGroup(after: .sidebar) {
            Section {
                Picker("Scaling Mode", selection: scalingModeBinding) {
                    Text("Dynamic").tag(ScalingMode.Dynamic)
                    Text("Actual Size").tag(ScalingMode.ActualSize)
                    Text("Fit to View").tag(ScalingMode.Fit)
                    Text("Fill View").tag(ScalingMode.Fill)
                }
                .pickerStyle(.inline)
                .labelsHidden()

                Picker("Rotation Mode", selection: rotationModeBinding) {
                    Text("Original").tag(RotationMode.Original)
                    Text("Rotated Right").tag(RotationMode.RotatedLeft)
                    Text("Rotated Left").tag(RotationMode.RotatedRight)
                    Text("Upside Down").tag(RotationMode.UpsideDown)
                }
                .pickerStyle(.inline)
                .labelsHidden()

                Picker("Sort By", selection: $sortBy.onChange(sortByChanged)) {
                    Text("Name").tag(SortOrder.name)
                    Text("Path").tag(SortOrder.path)
                    Text("Date").tag(SortOrder.date)
                    Text("Kind").tag(SortOrder.kind)
                    Text("Random").tag(SortOrder.random)
                }
            }
        }
    }
}
