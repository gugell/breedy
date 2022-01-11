//
//  BreedImageCollectionViewCell.swift
//  Breedy
//
//  Created by Ilia Gutu on 11.01.2022.
//

import UIKit
import Reusable
import Kingfisher

final class BreedImageCollectionViewCell: UICollectionViewCell, BindableType, Reusable {

    var viewModel: BreedImageCollectionViewCellViewModel!

    private let imageView = UIImageView()
    private let likeButton = UIButton()
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

        likeButton.add(to: self)
            .top(to: \.topAnchor, constant: 10)
            .trailing(to: \.trailingAnchor, constant: 10)
            .size(.init(width: 32, height: 32))

        likeButton.tintColor = Colors.kmfRed()
        likeButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .selected)

        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
    }

    @objc func didTapLikeButton() {
        likeButton.isSelected = !likeButton.isSelected
        AppEnvironment.profileServices.bookmarkImage(with: viewModel.url,
                                                     breed: viewModel.item)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bindViewModel() {
        imageView.loadBreedImage(viewModel.url)
        likeButton.isSelected = viewModel.isFavorite
    }
}

struct BreedImageCollectionViewCellViewModel: Hashable {
    let url: URL
    let isFavorite: Bool
    let item: Breed
}
