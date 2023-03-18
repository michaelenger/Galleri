//
//  DataStore.swift
//  Galleri
//
//  Created by Michael Enger on 18/03/2023.
//

import Foundation

/// Data store for the application. Expected to be used as an EnvironmentObject.
class DataStore: ObservableObject {
    @Published var currentImageUrl: URL? = nil
}
