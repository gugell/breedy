//
//  ProfileServices.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import Foundation

protocol ProfileServices {
    func isFavorite(_ url: URL, breed: Breed) -> Bool
    func bookmarkImage(with url: URL, breed: Breed)
}

final class ProfileServicesImpl: ProfileServices {

    private var cache: [Breed: [URL]] = [:]

    func isFavorite(_ url: URL, breed: Breed) -> Bool {
        return cache[breed]?.contains(url) ?? false
    }

    func bookmarkImage(with url: URL, breed: Breed) {
        var breedImages = cache[breed] ?? []
        breedImages.contains(url) ? breedImages = breedImages.filter { $0 != url } : breedImages.append(url)
        cache[breed] = breedImages
    }
}
