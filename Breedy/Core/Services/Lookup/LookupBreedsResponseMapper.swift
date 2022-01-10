//
//  LookupBreedsResponse.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import Foundation

enum LookupBreedsResponseMapper {
    static func mapResponse(_ response: LookupBreedsResponse) -> [Breed] {
        return response.message.reduce([Breed]()) { result, item in
            let subBreeds = item.value.map { Breed(name: $0, subBreeds: [])}
            let breed = Breed(name: item.key,
                              subBreeds: subBreeds)

            return result + [breed]
        }
    }
}

struct LookupBreedsResponse: Codable {
    let status: String
    let message: [String: [String]]
}

struct RandomImageResponse: Codable {
    let status: String
    let message: URL
}
