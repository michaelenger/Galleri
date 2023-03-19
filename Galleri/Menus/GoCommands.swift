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
                dataStore.nextMedia()
            }
            .disabled(!dataStore.hasMedia)
            .keyboardShortcut(.downArrow, modifiers: [])

            Button("Previous") {
                dataStore.previousMedia()
            }
            .disabled(!dataStore.hasMedia)
            .keyboardShortcut(.upArrow, modifiers: [])

            Button("First") {
                dataStore.firstMedia()
            }
            .disabled(!dataStore.hasMedia)
            .keyboardShortcut(.home, modifiers: [])

            Button("Last") {
                dataStore.lastMedia()
            }
            .disabled(!dataStore.hasMedia)
            .keyboardShortcut(.end, modifiers: [])
        }
    }
}
