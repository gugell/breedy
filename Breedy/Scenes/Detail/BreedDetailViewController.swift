//
//  BreedDetailViewController.swift
//  Breedy
//
//  Created by Ilia Gutu on 11.01.2022.
//
import UIKit
import Combine

final class BreedDetailViewController: UICollectionViewController, BindableType, HUDPresentable, BreedDetailView {

    var viewModel: BreedDetailViewModel!
    private var dataSource: BreedDetailDatasource!
    private var cancellables = Set<AnyCancellable>()
    var onClose: EmptyAction?

    private var pagingLayout: UICollectionViewLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }()

    init() {
        super.init(collectionViewLayout: pagingLayout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        configureDataSource()
        viewModel.input.viewDidLoad()
    }

    private func configureDataSource() {
        dataSource = BreedDetailDatasource(collectionView: collectionView)
    }

    private func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(didTapCloseButton))
    }

    func bindViewModel() {
        viewModel.$snapshot
            .sinkOnMainQueue { [weak self] snapshot in
                self?.dataSource.apply(snapshot, animatingDifferences: false)
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .sinkOnMainQueue { [weak self] isLoading in
                isLoading ? self?.showHUD() : self?.hideHUD()
            }
            .store(in: &cancellables)

        viewModel.output.showAlert
            .sinkOnMainQueue { [unowned self] alert in
                self.present(alert, animated: true)
            }
            .store(in: &cancellables)

        navigationItem.title = viewModel.title
    }

    @objc func didTapCloseButton() { onClose?() }
}
