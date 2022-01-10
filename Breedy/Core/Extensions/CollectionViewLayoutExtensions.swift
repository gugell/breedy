//
//  CollectionViewLayoutExtensions.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import UIKit

extension NSCollectionLayoutItem {
    static func withEntireSize() -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        return NSCollectionLayoutItem(layoutSize: itemSize)
    }

    static func entireWidth(withHeight height: NSCollectionLayoutDimension) -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: height)
        return NSCollectionLayoutItem(layoutSize: itemSize)
    }
}
