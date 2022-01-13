//
//  ProfileServices.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import Foundation
import Combine

typealias CacheContent = [Bookmark]

protocol ProfileServices {
    func isFavorite(_ url: URL, breed: Breed) -> Bool
    func bookmarkImage(with url: URL, breed: Breed)
    func allFavorites() -> AnyPublisher<CacheContent, Never>
}

final class ProfileServicesImpl: ProfileServices {

    private var cache: [Bookmark] = []
    private let storageStream = PassthroughSubject<CacheContent, Never>()

    func isFavorite(_ url: URL, breed: Breed) -> Bool {
        return cache.first(where: { $0.breed.name == breed.name && $0.images.contains(url) }) != nil
    }

    func allFavorites() -> AnyPublisher<CacheContent, Never> {
        return storageStream
            .prepend(cache)
            .eraseToAnyPublisher()
    }

    func bookmarkImage(with url: URL, breed: Breed) {
        defer {
            cache = cache.filter { !$0.images.isEmpty }
            storageStream.send(cache)
        }

        if let index = cache.firstIndex(where: { $0.breed == breed }) {
            var breedImages = cache[index].images
            breedImages.contains(url) ? breedImages = breedImages.filter { $0 != url } : breedImages.append(url)
            cache[index] = Bookmark(breed: breed, images: breedImages)
            return
        }
        cache.append(Bookmark(breed: breed, images: [url]))
    }
}
