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
                openPanel.allowsMultipleSelection = true
                openPanel.canChooseDirectories = true
                openPanel.canChooseFiles = true

                let response = openPanel.runModal()
                if response == .OK {
                    dataStore.setImages(from: openPanel.urls)
                }
            }.keyboardShortcut("o")

            Divider()
        }
    }
}
