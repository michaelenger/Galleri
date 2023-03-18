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

    /// All available images.
    private var imageUrls: [URL] = []

    /// Index of the current image.
    private var currentIndex: Int = 0

    /// Change the current image index by a given amount.
    private func changeImage(_ indexChangeAmount: Int) {
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

    /// Go to the next image.
    func nextImage() {
        changeImage(+1)
    }

    /// Go to the previous image.
    func previousImage() {
        changeImage(-1)
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
