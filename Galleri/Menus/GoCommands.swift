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
        let advanceByTwoBinding = Binding<Bool>(
            get: { dataStore.shouldAdvanceByTwo },
            set: { dataStore.shouldAdvanceByTwo = $0 })

        CommandMenu("Go") {
            Section {
                Button("Next") {
                    dataStore.goToNext()
                }
                .disabled(!dataStore.hasMedia)
                .keyboardShortcut(.downArrow, modifiers: [])

                Button("Previous") {
                    dataStore.goToPrevious()
                }
                .disabled(!dataStore.hasMedia)
                .keyboardShortcut(.upArrow, modifiers: [])

                Button("First") {
                    dataStore.goToFirst()
                }
                .disabled(!dataStore.hasMedia)
                .keyboardShortcut(.home, modifiers: [])

                Button("Last") {
                    dataStore.goToLast()
                }
                .disabled(!dataStore.hasMedia)
                .keyboardShortcut(.end, modifiers: [])
            }
            Section {
                Toggle(isOn: advanceByTwoBinding) {
                  // 2
                  Text("Advance by Two")
                }
                .keyboardShortcut("d")
            }
        }
    }
}
