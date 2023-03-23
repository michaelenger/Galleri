//
//  Utils.swift
//  Galleri
//
//  Created by Michael Enger on 23/03/2023.
//

import Foundation

/// Clamp a value to a minimum and maximum value.
func clamp(_ val: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
    if val < min {
        return min
    }

    if val > max {
        return max
    }

    return val
}
