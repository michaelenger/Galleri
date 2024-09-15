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
        let viewModeBinding = Binding<ViewMode>(
            get: { dataStore.viewMode },
            set: { dataStore.viewMode = $0 })

        CommandGroup(after: .sidebar) {
            Section {
                Picker("Scaling Mode", selection: scalingModeBinding) {
                    Text("Actual Size").tag(ScalingMode.ActualSize)
                    Text("Dynamic").tag(ScalingMode.Dynamic)
                    Text("Fill View").tag(ScalingMode.Fill)
                    Text("Fit to View").tag(ScalingMode.Fit)
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

                Picker("View Mode", selection: viewModeBinding) {
                    Text("Single").tag(ViewMode.Single)
                    Text("Double Left-to-Right").tag(ViewMode.DoubleLTR)
                    Text("Double Right-to-Left").tag(ViewMode.DoubleRTL)
                }
                .pickerStyle(.inline)
                .labelsHidden()
            }
            Section {
                Button("Change Scaling Mode") {
                    dataStore.changeScalingMode()
                }
                .keyboardShortcut("s")
                Button("Change Rotation Mode") {
                    dataStore.rotateLeft()
                }
                .keyboardShortcut("r")
                Button("Change View Mode") {
                    dataStore.changeViewMode()
                }
                .keyboardShortcut("d")
            }
            Section {
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
