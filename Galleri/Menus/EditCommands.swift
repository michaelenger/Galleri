//
//  EditCommands.swift
//  Galleri
//
//  Created by Michael Enger on 02/04/2023.
//

import SwiftUI

/// Contains the commands for the Edit menu.
struct EditCommands: Commands {
    @ObservedObject var dataStore: DataStore

    var body: some Commands {
        CommandGroup(after: .textEditing) {
            Section {
                Button("Move Item Up") {
                    dataStore.moveMediaUp(dataStore.selectedMediaID!)
                }
                .disabled(dataStore.selectedMediaID == nil)
                .keyboardShortcut(.upArrow, modifiers: [.command])

                Button("Move Item Down") {
                    dataStore.moveMediaDown(dataStore.selectedMediaID!)
                }
                .disabled(dataStore.selectedMediaID == nil)
                .keyboardShortcut(.downArrow, modifiers: [.command])

                Button("Move Item To Top") {
                    dataStore.moveMediaToTop(dataStore.selectedMediaID!)
                }
                .disabled(dataStore.selectedMediaID == nil)

                Button("Move Item To Bottom") {
                    dataStore.moveMediaToBottom(dataStore.selectedMediaID!)
                }
                .disabled(dataStore.selectedMediaID == nil)
            }
            Section {
                Button("Remove Item") {
                    dataStore.removeMedia(dataStore.selectedMediaID!)
                }
                .disabled(dataStore.selectedMediaID == nil)
                .keyboardShortcut(.delete, modifiers: [.command])
            }
        }
    }
}
