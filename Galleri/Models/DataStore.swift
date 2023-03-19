//
//  DataStore.swift
//  Galleri
//
//  Created by Michael Enger on 18/03/2023.
//

import SwiftUI

/// Data store for the application. Expected to be used as an EnvironmentObject.
class DataStore: NSObject, NSApplicationDelegate, ObservableObject {
    @AppStorage("sortBy") var sortBy = DefaultSettings.sortBy

    /// URL of the current media.
    @Published var currentMediaUrl: URL? = nil

    /// Whether there are any media.
    var hasMedia: Bool {
        get { return mediaUrls.count != 0 }
    }

    /// All available media.
    private var mediaUrls: [URL] = []

    /// Index of the current media.
    private var currentIndex: Int = 0

    /// Change the current media index by a given amount.
    private func changeMediaIndex(by indexChangeAmount: Int) {
        if mediaUrls.count == 0 {
            return // nothing to do here
        }

        currentIndex += indexChangeAmount

        if currentIndex >= mediaUrls.count {
            currentIndex -= mediaUrls.count
        } else if currentIndex < 0 {
            currentIndex += mediaUrls.count
        }

        if currentMediaUrl != mediaUrls[currentIndex] {
            currentMediaUrl = mediaUrls[currentIndex] // only update if absolutely necessary
        }
    }

    /// Change the current media index to a specified value.
    private func changeMediaIndex(to targetIndex: Int) {
        currentIndex = targetIndex
        if currentMediaUrl != mediaUrls[currentIndex] {
            currentMediaUrl = mediaUrls[currentIndex] // only update if absolutely necessary
        }
    }

    /// Fill the media list with items from a directory.
    ///
    /// This will recursively go through the directory and add any supported media items to the list.
    private func fillMedia(from directory: URL) {
        let items = try? FileManager.default.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: [.typeIdentifierKey],
            options: .skipsHiddenFiles
        )

        for item in items! {
            if item.hasDirectoryPath {
                fillMedia(from: item)
            } else {
                if item.isImage {
                    mediaUrls.append(item)
                }
            }
        }
    }

    /// Handle drag-events to the dock icon.
    func application(_ application: NSApplication, open urls: [URL]) {
        loadMedia(from: urls)
    }

    /// Go to the first media.
    func goToFirst() {
        changeMediaIndex(to: 0)
    }

    /// Go to the last media.
    func goToLast() {
        let targetIndex = mediaUrls.count != 0 ? (mediaUrls.count - 1) : 0
        changeMediaIndex(to: targetIndex)
    }

    /// Go to the next media.
    func goToNext() {
        changeMediaIndex(by: +1)
    }

    /// Go to the previous media.
    func goToPrevious() {
        changeMediaIndex(by: -1)
    }

    /// Set a list of media based on the files and directories provided.
    ///
    /// This will iterate through the provided URLs and add any supported media to the media list. If the URL is a directory it will recursively go through it and fill the media list with anything it can find.
    func loadMedia(from urls: [URL]) {
        mediaUrls = []
        currentIndex = 0

        for url in urls {
            if url.hasDirectoryPath {
                fillMedia(from: url)
            } else if url.isImage {
                mediaUrls.append(url)
            }
        }

        sortMedia()
        currentMediaUrl = mediaUrls.count != 0 ? mediaUrls[currentIndex] : nil
    }

    /// Sort the media list based on the sort order.
    func sortMedia() {
        if mediaUrls.count < 2 {
            return // nothing to do here
        }

        // TODO maintain index position?

        switch (sortBy) {
        case .name:
            mediaUrls.sort(by: { a, b in
                return a.path(percentEncoded: false) < b.path(percentEncoded: false)
            })
        default:
            print("Unhandled sort order: \(sortBy)")
        }
    }
}
