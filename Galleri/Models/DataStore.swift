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

    private func changeImage(to targetIndex: Int) {
        currentIndex = targetIndex
        if currentImageUrl != imageUrls[currentIndex] {
            currentImageUrl = imageUrls[currentIndex] // only update if absolutely necessary
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

    /// Set an image as the only available image.
    func setImage(url: URL) {
        setImages(urls: [url])
    }

    /// Set a list of images as the available images.
    func setImages(urls: [URL]) {
        imageUrls = urls
        currentIndex = 0
        currentImageUrl = imageUrls[currentIndex]
    }
}
