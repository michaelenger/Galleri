//
//  GoCommands.swift
//  Galleri
//
//  Created by Michael Enger on 18/03/2023.
//

import SwiftUI

/// Contains the commands for the Go menu.
struct GoCommands: Commands {
    var dataStore: DataStore

    var body: some Commands {
        let slideshowActiveBinding = Binding<Bool>(
            get: { dataStore.slideshowActive },
            set: { dataStore.slideshowActive = $0 })
        let slideshowTimeBinding = Binding<SlideshowTime>(
            get: { dataStore.slideshowTime },
            set: { dataStore.slideshowTime = $0 })

        CommandMenu("Go") {
            Section {
                Button("Next") {
                    dataStore.goToNext()
                }
                .keyboardShortcut(.downArrow, modifiers: [])
                .disabled(!dataStore.hasMedia)

                Button("Previous") {
                    dataStore.goToPrevious()
                }
                .keyboardShortcut(.upArrow, modifiers: [])
                .disabled(!dataStore.hasMedia)

                Button("First") {
                    dataStore.goToFirst()
                }
                .keyboardShortcut(.home, modifiers: [])
                .disabled(!dataStore.hasMedia)

                Button("Last") {
                    dataStore.goToLast()
                }
                .keyboardShortcut(.end, modifiers: [])
                .disabled(!dataStore.hasMedia)
            }
            Section {
                Picker("Slideshow Time", selection: slideshowTimeBinding) {
                    Text("One Second").tag(SlideshowTime.OneSecond)
                    Text("Three Seconds").tag(SlideshowTime.ThreeSeconds)
                    Text("Five Seconds").tag(SlideshowTime.FiveSeconds)
                    Text("Ten Seconds").tag(SlideshowTime.TenSeconds)
                }
                Toggle("Activate Slideshow", isOn: slideshowActiveBinding)
                    .keyboardShortcut("g")
                    .disabled(!dataStore.hasMedia)
            }
        }
    }
}
