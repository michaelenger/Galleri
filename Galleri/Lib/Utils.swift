//
//  Utils.swift
//  Galleri
//
//  Created by Michael Enger on 23/03/2023.
//

import Foundation
import os

let logger = Logger()

/// Clamp a value to a minimum and maximum value.
func clamp<T: Comparable>(_ val: T, min: T, max: T) -> T {
    if val < min {
        return min
    }

    if val > max {
        return max
    }

    return val
}
