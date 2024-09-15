//
//  EditCommands.swift
//  Galleri
//
//  Created by Michael Enger on 02/04/2023.
//

import SwiftUI

/// Contains the commands for the Edit menu.
struct EditCommands: Commands {
    var dataStore: DataStore

    var body: some Commands {
        CommandGroup(after: .textEditing) {
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
