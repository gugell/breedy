//
//  AppServicesManager.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import Foundation
import UIKit

/// This is only a tagging protocol.
/// It doesn't add more functionalities yet.
public protocol ApplicationService: UIApplicationDelegate {}

open class PluggableApplicationDelegate: UIResponder, UIApplicationDelegate {

    public var window: UIWindow?

    open var services: [ApplicationService] { return [] }

    lazy var _services: [ApplicationService] = {
        return self.services
    }()

    @discardableResult
    internal func apply<T, S>(_ work: (ApplicationService,
                                       @escaping (T) -> Void) -> S?,
                              completionHandler: @escaping ([T]) -> Void) -> [S] {
        let dispatchGroup = DispatchGroup()
        var results: [T] = []
        var returns: [S] = []

        for service in _services {
            dispatchGroup.enter()
            let returned = work(service, { result in
                results.append(result)
                dispatchGroup.leave()
            })
            if let returned = returned {
                returns.append(returned)
            } else { // delegate doesn't implement method
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            completionHandler(results)
        }

        return returns
    }
}
