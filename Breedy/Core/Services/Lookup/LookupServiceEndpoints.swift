//
//  LookupServiceEndpoints.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//
import Moya

enum LookupServiceEndpoints {
    case breeds
    case subBreeds(breed: String)
    case randomBreedImage(breed: String)
    case breedImages(breed: String)
    case subBreedImages(breed: String, subBreed: String)
}

extension LookupServiceEndpoints: TargetType {
    var baseURL: URL {
        return AppEnvironment.baseURL
    }

    var path: String {
        switch self {
        case .breeds:
            return "/breeds/list/all"
        case .breedImages(let breed):
            return "/breed/\(breed)/images"
        case .subBreedImages(let breed, let subBreed):
            return "/breed/\(breed)/\(subBreed)/images"
        case .subBreeds(let breed):
            return "/breed/\(breed)/list"
        case .randomBreedImage(let breed):
            return "/breed/\(breed)/images/random"
        }
    }

    var method: Method {
        return .get
    }

    var encoding: ParameterEncoding {
        return URLEncoding.default
    }

    var task: Task {
        return .requestPlain
    }

    var headers: [String: String]? {
        return nil
    }
}
