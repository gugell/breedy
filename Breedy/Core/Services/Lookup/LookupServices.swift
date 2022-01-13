//
//  LookupServices.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import Combine
import Foundation

protocol LookupService {
    func lookupBreeds() -> Deferred<Future<[Breed], LookupServiceError>>
    func lookupRandomBreedImage(_ breed: String,
                                completionHandler: @escaping  (Result<URL, LookupServiceError>) -> Void)
    func lookupBreedImages(_ breed: String,
                           completionHandler: @escaping  (Result<[URL], LookupServiceError>) -> Void)
}

public enum LookupServiceError: Error {
    case failure(Error)
    case badResponse
    case reason(String)

    var localizedDescription: String {
        switch self {
        case .badResponse:
            return "Bad response from server"
        case .failure(let error):
            return error.localizedDescription
        case .reason(let message):
            return message
        }
    }

    var errorDescription: String? {
        return localizedDescription
    }
}

final class LookupServiceImpl: LookupService {

    private let provider = _MoyaProvider.of(ofType: LookupServiceEndpoints.self)

    func lookupBreeds() -> Deferred<Future<[Breed], LookupServiceError>> {
        Deferred {
            Future { promise in
                self.provider.request(.breeds,
                                      objectType: LookupBreedsResponse.self) { returnData in
                    promise(.success(LookupBreedsResponseMapper.mapResponse(returnData)))
                } failure: { error in
                    promise(.failure(LookupServiceError.failure(error)))
                }
            }
        }
    }

    func lookupBreedImages(_ breed: String,
                           completionHandler: @escaping  (Result<[URL], LookupServiceError>) -> Void) {
        provider.request(.breedImages(breed: breed),
                              objectType: APIResponse<[URL]>.self) { returnData in
            completionHandler(.success(returnData.message))
        } failure: { error in
            completionHandler(.failure(LookupServiceError.failure(error)))
        }
    }

    func lookupRandomBreedImage(_ breed: String,
                                completionHandler: @escaping  (Result<URL, LookupServiceError>) -> Void) {
        provider.request(.randomBreedImage(breed: breed),
                              objectType: APIResponse<URL>.self) { returnData in
            completionHandler(.success(returnData.message))
        } failure: { error in
            completionHandler(.failure(LookupServiceError.failure(error)))
        }
    }
}

extension LookupService {
    func lookupBreedImagesPublisher(_ breed: String) -> Deferred<Future<[URL], LookupServiceError>> {
        Deferred {
            Future { promise in
                self.lookupBreedImages(breed, completionHandler: promise)
            }
        }
    }
}
