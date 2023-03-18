//
//  FileCommands.swift
//  Galleri
//
//  Created by Michael Enger on 18/03/2023.
//

import SwiftUI

/// Contains the commands for the File menu.
struct FileCommands: Commands {
    @ObservedObject var dataStore: DataStore

    var body: some Commands {
        CommandGroup(after: .newItem) {
            Divider()

            Button("Open...") {
                let openPanel = NSOpenPanel()
                openPanel.allowedContentTypes = [.image]
                openPanel.allowsMultipleSelection = false
                openPanel.canChooseDirectories = false
                openPanel.canChooseFiles = true

                let response = openPanel.runModal()
                dataStore.currentImageUrl = response == .OK ? openPanel.url : nil
            }.keyboardShortcut("o")

            Divider()
        }
    }
}
