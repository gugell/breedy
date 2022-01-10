//
//  ImageFetchers.swift
//  Breedy
//
//  Created by Ilia Gutu on 11.01.2022.
//

import Kingfisher
import UIKit

extension UIImageView {
    func loadRandomBreedImage(_ breed: String) {
        kf.indicatorType = .activity
        AppEnvironment.lookupService.lookupRandomBreedImage(breed) { [weak self] result in
            switch result {
            case .success(let url):
                self?.kf.setImage(with: url)
            case .failure:
                self?.image = UIImage(systemName: "exclamationmark.circle")
            }
        }
    }
}
