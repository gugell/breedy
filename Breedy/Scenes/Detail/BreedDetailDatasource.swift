//
//  BreedDetailDatasource.swift
//  Breedy
//
//  Created by Ilia Gutu on 11.01.2022.
//

import UIKit
import Reusable

final class BreedDetailDatasource: UICollectionViewDiffableDataSource<Int, BreedImageCollectionViewCellViewModel> {

    init(collectionView: UICollectionView) {
        collectionView.register(cellType: BreedImageCollectionViewCell.self)

        super.init(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            var cell = collectionView.dequeueReusableCell(for: indexPath, cellType: BreedImageCollectionViewCell.self)
            cell.bind(to: item)

            return cell
        }
    }
}
