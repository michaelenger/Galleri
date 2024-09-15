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

    /// Wheter the slideshow is active.
    private var privateSlideshowActive: Bool = false

    /// Amount of time to wait between slides.
    private var privateSlideshowTime: SlideshowTime = .ThreeSeconds

    /// The timer keeping the slideshow active.
    private var slideshowTimer: Timer? = nil

    /// ID of the currently selected media item.
    var selectedMediaID: Media.ID?

    /// List of media.
    var mediaItems: [Media] = []

    /// Rotation mode of the media.
    var rotationMode: RotationMode = .Original

    /// Whether the slideshow is active.
    var slideshowActive: Bool {
        get {
            privateSlideshowActive
        }
        set(newSetting) {
            slideshowTimer?.invalidate() // stop any active timer
            slideshowTimer = nil
            privateSlideshowActive = newSetting

            if privateSlideshowActive {
                let interval = switch privateSlideshowTime {
                case .OneSecond:
                    1.0
                case .ThreeSeconds:
                    3.0
                case .FiveSeconds:
                    5.0
                case .TenSeconds:
                    10.0
                }

                slideshowTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _timer in
                    self.goToNext()
                }
            }
        }
    }

    /// Amount of time to wait between slides.
    var slideshowTime: SlideshowTime {
        get {
            privateSlideshowTime
        }
        set(newSetting) {
            if newSetting == slideshowTime {
                return
            }

            privateSlideshowTime = newSetting
            slideshowActive = privateSlideshowActive // reset the timer
        }
    }

    /// Scaling mode of the media.
    var scalingMode: ScalingMode = .Dynamic

    /// Media view mode.
    var viewMode: ViewMode = .Single

    /// The current media to be viewed.
    var currentMediaItem: ViewableMedia? {
        get {
            if !hasMedia {
                return nil
            }

            return switch viewMode {
            case .Single:
                ViewableMedia(self[selectedMediaID]!)
            case .DoubleLTR:
                ViewableMedia(
                    self[selectedMediaID]!,
                    mediaItems[getMediaIndex(offset: 1)]
                )
            case .DoubleRTL:
                ViewableMedia(
                    mediaItems[getMediaIndex(offset: 1)],
                    self[selectedMediaID]!
                )
            }

        }
    }

    /// Whether there are any media.
    var hasMedia: Bool {
        get { return mediaItems.count != 0 }
    }

    /// Change the current media index by a given amount.
    private func changeMediaIndex(by indexChangeAmount: Int) {
        if mediaItems.count == 0 {
            return // nothing to do here
        }

        changeMediaIndex(to: getMediaIndex(offset: indexChangeAmount))
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

    /// Get the index of a media item offset by an amount.
    private func getMediaIndex(offset: Int) -> Int {
        var mediaIndex = mediaItems.firstIndex(where: { $0.id == selectedMediaID }) ?? 0

        mediaIndex += offset

        if mediaIndex >= mediaItems.count {
            mediaIndex -= mediaItems.count
        } else if mediaIndex < 0 {
            mediaIndex += mediaItems.count
        }

        return mediaIndex
    }

    /// Handle drag-events to the dock icon.
    func application(_ application: NSApplication, open urls: [URL]) {
        loadMedia(from: urls)
    }

    /// Change the current scaling mode.
    func changeScalingMode() {
        switch scalingMode {
        case .ActualSize:
            scalingMode = .Dynamic
        case .Dynamic:
            scalingMode = .Fill
        case .Fill:
            scalingMode = .Fit
        case .Fit:
            scalingMode = .ActualSize
        }
    }

    /// Change the current view mode.
    func changeViewMode() {
        switch viewMode {
        case .Single:
            viewMode = .DoubleLTR
        case .DoubleLTR:
            viewMode = .DoubleRTL
        case .DoubleRTL:
            viewMode = .Single
        }
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
        let amount = viewMode == .Single ? 1 : 2
        changeMediaIndex(by: amount)
    }

    /// Go to the previous media.
    func goToPrevious() {
        let amount = viewMode == .Single ? 1 : 2
        changeMediaIndex(by: -amount)
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
