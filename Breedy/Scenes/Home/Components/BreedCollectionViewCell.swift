//
//  BreedCollectionViewCell.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import UIKit
import Reusable
import Kingfisher

class BreedCollectionViewCell: UICollectionViewCell, BindableType, Reusable {

    var viewModel: BreedCollectionViewCellViewModel!

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let overlayView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    private func setupUI() {
        imageView.add(to: self)
            .pinToEdges()

        overlayView.add(to: self)
            .pinToEdges()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.2)

        titleLabel.add(to: self)
            .leading(to: \.leadingAnchor, constant: 20)
            .trailing(to: \.trailingAnchor, constant: 20)
            .bottom(to: \.bottomAnchor, constant: 5)

        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bindViewModel() {
        titleLabel.text = viewModel.name
        imageView.loadRandomBreedImage(viewModel.name)
    }
}

struct BreedCollectionViewCellViewModel: Hashable {
    let name: String
    let item: Breed
}
