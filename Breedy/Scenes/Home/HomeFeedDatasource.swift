//
//  HomeFeedDatasource.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import UIKit
import Reusable

class HomeFeedDatasource: UICollectionViewDiffableDataSource<Int, BreedCollectionViewCellViewModel> {

    init(collectionView: UICollectionView) {
        collectionView.register(cellType: BreedCollectionViewCell.self)

        super.init(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            var cell = collectionView.dequeueReusableCell(for: indexPath, cellType: BreedCollectionViewCell.self)
            cell.bind(to: item)

            return cell
        }
    }
}
