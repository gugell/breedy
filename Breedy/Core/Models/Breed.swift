//
//  Breed.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import Foundation

struct Breed: Hashable {
    let name: String
    let subBreeds: [Breed]
}

extension Breed: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        let name = try container.decode(String.self)
        self.init(name: name, subBreeds: [])
    }
}
