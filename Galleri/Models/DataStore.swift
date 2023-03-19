//
//  DataStore.swift
//  Galleri
//
//  Created by Michael Enger on 18/03/2023.
//

import Foundation

/// Data store for the application. Expected to be used as an EnvironmentObject.
class DataStore: ObservableObject {
    /// URL of the current image.
    @Published var currentImageUrl: URL? = nil

    /// Whether there are any images.
    var hasImages: Bool {
        get { return imageUrls.count != 0 }
    }

    /// All available images.
    private var imageUrls: [URL] = []

    /// Index of the current image.
    private var currentIndex: Int = 0

    /// Change the current image index by a given amount.
    private func changeImage(by indexChangeAmount: Int) {
        if imageUrls.count == 0 {
            return // nothing to do here
        }

        currentIndex += indexChangeAmount

        if currentIndex >= imageUrls.count {
            currentIndex -= imageUrls.count
        } else if currentIndex < 0 {
            currentIndex += imageUrls.count
        }

        if currentImageUrl != imageUrls[currentIndex] {
            currentImageUrl = imageUrls[currentIndex] // only update if absolutely necessary
        }
    }

    /// Change the current image index to a specified value.
    private func changeImage(to targetIndex: Int) {
        currentIndex = targetIndex
        if currentImageUrl != imageUrls[currentIndex] {
            currentImageUrl = imageUrls[currentIndex] // only update if absolutely necessary
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
                    imageUrls.append(item)
                }
            }
        }
    }

    /// Go to the first image.
    func firstImage() {
        changeImage(to: 0)
    }

    /// Go to the last image.
    func lastImage() {
        let targetIndex = imageUrls.count != 0 ? (imageUrls.count - 1) : 0
        changeImage(to: targetIndex)
    }

    /// Go to the next image.
    func nextImage() {
        changeImage(by: +1)
    }

    /// Go to the previous image.
    func previousImage() {
        changeImage(by: -1)
    }

    /// Set a list of images based on the files and directories provided.
    ///
    /// This will iterate through the provided URLs and add any supported media to the media list. If the URL is a directory it will recursively go through it and fill the media list with anything it can find.
    func setImages(from urls: [URL]) {
        imageUrls = []
        currentIndex = 0

        for url in urls {
            if url.hasDirectoryPath {
                fillMedia(from: url)
            } else {
                imageUrls.append(url)
            }
        }

        // TODO allow users to choose how to sort
        imageUrls.sort(by: { a, b in
            return a.path(percentEncoded: false) < b.path(percentEncoded: false)
        })

        currentImageUrl = imageUrls.count != 0 ? imageUrls[currentIndex] : nil
    }
}
