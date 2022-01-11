//
//  FavoritesViewController.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import UIKit
import VanillaConstraints
import Reusable
import Combine

final class FavoritesViewController: UICollectionViewController, BindableType, HUDPresentable, FavoritesView {

    var viewModel: FavoritesViewModel!
    private var dataSource: FavoriteBreedDatasource!

    private var cancellables = Set<AnyCancellable>()

    private static let sectionHeaderElementKind = "section-header-element-kind"

    private var gridLayout: UICollectionViewLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: headerSize,
          elementKind: FavoritesViewController.sectionHeaderElementKind, alignment: .top)

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }()

    init() {
        super.init(collectionViewLayout: gridLayout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureDataSource()
        viewModel.input.viewDidLoad()
    }

    private func configureDataSource() {
        dataSource = FavoriteBreedDatasource(collectionView: collectionView)
        collectionView.register(supplementaryViewType: SectionHeaderView.self,
                                ofKind: FavoritesViewController.sectionHeaderElementKind)

        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, idx -> UICollectionReusableView? in

            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             for: idx,
                                                                             viewType: SectionHeaderView.self)
            let headerItem = self?.dataSource.snapshot().sectionIdentifiers[idx.section]
            headerView.titleLabel.text = headerItem?.capitalized

            return headerView
        }
    }

    func bindViewModel() {
        viewModel.$snapshot
            .sinkOnMainQueue { [weak self] snapshot in
                self?.dataSource.apply(snapshot, animatingDifferences: false)
            }
            .store(in: &cancellables)

        navigationItem.title = L10n.Favorites.title
    }
}
