//
//  GalleriApp.swift
//  Galleri
//
//  Created by Michael Enger on 18/03/2023.
//

import SwiftUI

@main
struct GalleriApp: App {
    @StateObject var dataStore = DataStore()

    var body: some Scene {
        Window("Galleri", id: "main") {
            ContentView()
                .environmentObject(dataStore)
                .onAppear {
                    NSWindow.allowsAutomaticWindowTabbing = false
                }
        }
        .commands() {
            FileCommands(dataStore: dataStore)
            GoCommands(dataStore: dataStore)
        }
    }
}
