//
//  MoyaProvider+Codable.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import Foundation
import Moya

public extension MoyaProvider {

    @discardableResult
    func request<T: Codable>(_ target: Target,
                             objectType: T.Type,
                             path: String? = nil,
                             success: ((_ returnData: T) -> Void)?,
                             failure: ((_ Error: MoyaError) -> Void)?) -> Cancellable? {

        return request(target, completion: {
            switch $0 {
            case .success(let result):
                do {
                    let returnData = try result.mapObject(objectType.self,
                                                                path: path)
                    success?(returnData)
                } catch {
                    failure?(MoyaError.jsonMapping(result))
                }
            case .failure(let error):
                failure?(error)
            }
        })
    }

    @discardableResult
    func request<T: Codable>(_ target: Target,
                             arrayOfType: T.Type,
                             path: String? = nil,
                             success: ((_ returnData: [T]) -> Void)?,
                             failure: ((_ Error: MoyaError) -> Void)?) -> Cancellable? {

        return request(target, completion: {

            switch $0 {
            case .success(let result):
                do {
                    let returnData = try result.mapArray(arrayOfType.self,
                                                                path: path)
                    success?(returnData)
                } catch {
                    failure?(MoyaError.jsonMapping(result))
                }
            case .failure(let error):
                failure?(error)
            }
        })
    }
}
