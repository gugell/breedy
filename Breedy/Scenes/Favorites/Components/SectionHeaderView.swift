//
//  SectionHeaderView.swift
//  Breedy
//
//  Created by Ilia Gutu on 11.01.2022.
//

import VanillaConstraints
import Reusable

final class SectionHeaderView: UICollectionReusableView, Reusable {

    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        titleLabel.add(to: self)
            .leading(to: \.leadingAnchor, constant: 10)
            .top(to: \.topAnchor, constant: 5)
            .bottom(to: \.bottomAnchor, constant: 5)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = Colors.kmfBlack()
    }
}
