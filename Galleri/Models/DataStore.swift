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

    /// List of media.
    private var mediaItems: [Media] = []

    /// Whether there are any media.
    var hasMedia: Bool {
        get { return mediaItems.count != 0 }
    }

    /// Index of the current media.
    private var currentIndex: Int = 0

    /// Change the current media index by a given amount.
    private func changeMediaIndex(by indexChangeAmount: Int) {
        if mediaItems.count == 0 {
            return // nothing to do here
        }

        currentIndex += indexChangeAmount

        if currentIndex >= mediaItems.count {
            currentIndex -= mediaItems.count
        } else if currentIndex < 0 {
            currentIndex += mediaItems.count
        }

        changeMediaIndex(to: currentIndex)
    }

    /// Change the current media index to a specified value.
    private func changeMediaIndex(to targetIndex: Int) {
        currentIndex = targetIndex
        if currentMediaUrl != mediaItems[currentIndex].url {
            currentMediaUrl = mediaItems[currentIndex].url // only update if absolutely necessary
        }
    }

    /// Get all the compatible media from a given directory.
    ///
    /// This will recursively go through the directory and add any supported media items to the list.
    private func getMedia(from directory: URL) -> [URL] {
        var mediaUrls: [URL] = []
        let items = try? FileManager.default.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: [.typeIdentifierKey],
            options: .skipsHiddenFiles
        )

        for item in items! {
            if item.hasDirectoryPath {
                mediaUrls += getMedia(from: item)
            } else {
                if item.isImage {
                    mediaUrls.append(item)
                }
            }
        }

        return mediaUrls
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
        let targetIndex = mediaItems.count != 0 ? (mediaItems.count - 1) : 0
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
        var mediaUrls: [URL] = []
        currentIndex = 0

        for url in urls {
            if url.hasDirectoryPath {
                mediaUrls += getMedia(from: url)
            } else if url.isImage {
                mediaUrls.append(url)
            }
        }

        mediaItems = mediaUrls.map({ url in
            Media(url)
        })

        sortMediaItems()
        currentMediaUrl = mediaItems.count != 0 ? mediaItems[currentIndex].url : nil
    }

    /// Sort the media list based on the sort order.
    func sortMediaItems() {
        if mediaItems.count < 2 {
            return // nothing to do here
        }

        // TODO maintain index position?

        if sortBy == .random {
            mediaItems.shuffle()
            return
        }

        mediaItems.sort(by: { a, b in
            switch (sortBy) {
            case .date:
                return a.creationDate! < b.creationDate!
            case .kind:
                return a.url.contentType! < b.url.contentType!
            case .name:
                return a.url.lastPathComponent < b.url.lastPathComponent
            case .path:
                return a.url.path(percentEncoded: false) < b.url.path(percentEncoded: false)
            case .size:
                return a.size < b.size
            default:
                print("Unhandled sort order: \(sortBy)")
                return a.url.path(percentEncoded: false) < b.url.path(percentEncoded: false)
            }
        })
    }
}
