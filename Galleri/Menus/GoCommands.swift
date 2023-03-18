//
//  GoCommands.swift
//  Galleri
//
//  Created by Michael Enger on 18/03/2023.
//

import SwiftUI

/// Contains the commands for the Go menu.
struct GoCommands: Commands {
    @ObservedObject var dataStore: DataStore

    var body: some Commands {
        CommandMenu("Go") {
            Button("Next") {
                dataStore.nextImage()
            }
            .disabled(!dataStore.hasImages)
            .keyboardShortcut(.downArrow, modifiers: [])

            Button("Previous") {
                dataStore.previousImage()
            }
            .disabled(!dataStore.hasImages)
            .keyboardShortcut(.upArrow, modifiers: [])

            Button("First") {
                dataStore.firstImage()
            }
            .disabled(!dataStore.hasImages)
            .keyboardShortcut(.home, modifiers: [])

            Button("Last") {
                dataStore.lastImage()
            }
            .disabled(!dataStore.hasImages)
            .keyboardShortcut(.end, modifiers: [])
        }
    }
}
