//
//  DataStore.swift
//  Galleri
//
//  Created by Michael Enger on 18/03/2023.
//

import Observation
import SwiftUI

/// Data store for the application. Expected to be used as an EnvironmentObject.
@Observable class DataStore: NSObject, NSApplicationDelegate {
    @ObservationIgnored @AppStorage("sortBy") var sortBy = DEFAULT_SORT_BY

    /// ID of the currently selected media item.
    var selectedMediaID: Media.ID?

    /// List of media.
    var mediaItems: [Media] = []

    /// Rotation mode of the media.
    var rotationMode: RotationMode = .Original

    /// Scaling mode of the media.
    var scalingMode: ScalingMode = .Dynamic

    /// Whether there are any media.
    var hasMedia: Bool {
        get { return mediaItems.count != 0 }
    }

    /// Change the current media index by a given amount.
    private func changeMediaIndex(by indexChangeAmount: Int) {
        if mediaItems.count == 0 {
            return // nothing to do here
        }

        var currentIndex = mediaItems.firstIndex(where: { $0.id == selectedMediaID }) ?? 0

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
        if selectedMediaID != mediaItems[targetIndex].id {
            selectedMediaID = mediaItems[targetIndex].id // only update if absolutely necessary
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

    /// Shift a media item from one index to another.
    private func shiftMedia(from: Int, to: Int) {
        if (from == to || from < 0 || to >= mediaItems.count) {
            return  // nothing to do
        }

        logger.log("Shifting media (\(self.mediaItems[from].id)) from \(from) to \(to)")

        let media = mediaItems.remove(at: from)
        mediaItems.insert(media, at: to)
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

        let urlsListText = urls.map({ url in url.path(percentEncoded: false) }).joined(separator: ", ")
        logger.log("Loading media from: [\(urlsListText)]")

        for url in urls {
            if url.hasDirectoryPath {
                mediaUrls += getMedia(from: url)
            } else if url.isImage {
                mediaUrls.append(url)
            } else {
                logger.warning("Skipping unsupported media: \(url.path(percentEncoded: false))")
            }
        }

        let mediaUrlsText = mediaUrls.map({ url in url.path(percentEncoded: false) }).joined(separator: ", ")
        logger.log("Loading media: [\(mediaUrlsText)]")
        mediaItems = mediaUrls.map({ url in
            Media(url)
        })

        sortMediaItems()
        selectedMediaID = mediaItems.count != 0 ? mediaItems.first!.id : nil
    }

    /// Move the specified media down in the list.
    func moveMediaDown(_ id: Media.ID) {
        let mediaIndex = mediaItems.firstIndex(where: { $0.id == id }) ?? 0

        shiftMedia(from: mediaIndex, to: mediaIndex + 1)
    }

    /// Move the specified media to the top of the list.
    func moveMediaToBottom(_ id: Media.ID) {
        let mediaIndex = mediaItems.firstIndex(where: { $0.id == id }) ?? 0

        shiftMedia(from: mediaIndex, to: mediaItems.count - 1)
    }

    /// Move the specified media to the top of the list.
    func moveMediaToTop(_ id: Media.ID) {
        let mediaIndex = mediaItems.firstIndex(where: { $0.id == id }) ?? 0

        shiftMedia(from: mediaIndex, to: 0)
    }

    /// Move the specified media up in the list.
    func moveMediaUp(_ id: Media.ID) {
        let mediaIndex = mediaItems.firstIndex(where: { $0.id == id }) ?? 0

        shiftMedia(from: mediaIndex, to: mediaIndex - 1)
    }

    /// Remove media from the given ID.
    func removeMedia(_ id: Media.ID) {
        var mediaIndex = mediaItems.firstIndex(where: { $0.id == id }) ?? 0
        logger.log("Removing media (\(id)) at \(mediaIndex)")

        mediaItems.remove(at: mediaIndex)

        if selectedMediaID == id {
            if !mediaItems.isEmpty {
                mediaIndex = mediaIndex == mediaItems.count ? mediaIndex - 1 : mediaIndex
                selectedMediaID = mediaItems[mediaIndex].id
            } else {
                selectedMediaID = nil
            }
        }
    }

    /// Change the rotation mode by rotating left.
    func rotateLeft() {
        rotationMode = switch rotationMode {
        case .Original:
            .RotatedLeft
        case .RotatedRight:
            .Original
        case .RotatedLeft:
            .UpsideDown
        case .UpsideDown:
            .RotatedRight
        }
    }

    /// Sort the media list based on the sort order.
    func sortMediaItems() {
        if mediaItems.count < 2 {
            return // nothing to do here
        }

        logger.log("Sorting media by \(self.sortBy.rawValue)")

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
            default:
                logger.error("Unhandled sort order: \(self.sortBy.rawValue)")
                return a.url.path(percentEncoded: false) < b.url.path(percentEncoded: false)
            }
        })
    }

    subscript(mediaID: Media.ID?) -> Media? {
        get {
            if let id = mediaID {
                return mediaItems.first(where: { $0.id == id }) ?? nil
            }
            return nil
        }

        set(newValue) {
            if let id = mediaID {
                mediaItems[mediaItems.firstIndex(where: { $0.id == id })!] = newValue!
            }
        }
    }
}
