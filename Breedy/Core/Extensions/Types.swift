//
//  Types.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import Foundation

typealias Action<T, U> = (T) -> U
typealias EmptyAction = () -> Void

extension ColorAsset {
    func callAsFunction() -> Color {
        return color
    }
}
