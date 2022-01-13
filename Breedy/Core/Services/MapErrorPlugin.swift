//
//  MapErrorPlugin.swift
//  Breedy
//
//  Created by Ilia Gutu on 13.01.2022.
//

import Moya

struct MapErrorPlugin: PluginType {
    func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError> {
        switch result {
        case .success(let response):
            do {
                return .success(try response.filterSuccessfulStatusCodes())
            } catch {
                if let mappedResponse = try? response.mapObject(UnderlyingError.self) {
                    return .failure(.underlying(NSError.withError(mappedResponse, response: response), response))
                }
                return .failure(.underlying(error, nil))
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}

private struct UnderlyingError: Codable {
    let status: String?
    let error: String?
    let message: String?

    var isSuccessful: Bool {
        return status == "success"
    }
}

fileprivate extension NSError {
    static func withError(_ error: UnderlyingError, response: Moya.Response) -> NSError {
        // swiftlint:disable:next line_length
        let reason = error.error ?? error.message ?? "Unknown error happened\n Status code: \(response.statusCode)\n Debug Description: \(response.debugDescription)"
        return NSError(
            domain: Bundle.main.bundleIdentifier ?? "",
            code: -1,
            userInfo: [NSLocalizedDescriptionKey: reason]
        )
    }
}
