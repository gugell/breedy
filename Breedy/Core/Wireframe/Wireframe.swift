//
//  Wireframe.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import Foundation

protocol Wireframe: Presentable {
    func present(_ module: Presentable?)
    func presentEmbedded(_ module: Presentable?, animated: Bool)
    func presentEmbedded(_ module: Presentable?)
    func present(_ module: Presentable?, animated: Bool)

    func push(_ module: Presentable?)
    func push(_ module: Presentable?, completion: Action<Void>?)
    func push(_ module: Presentable?, animated: Bool)
    func push(_ module: Presentable?, animated: Bool, completion: Action<Void>?)

    func popModule()
    func popModule(animated: Bool)

    func dismissModule()
    func dismissModule(animated: Bool, completion: Action<Void>?)

    func setRootModule(_ module: Presentable?)
    func setRootModule(_ module: Presentable?, hideBar: Bool)

    func popToRootModule(animated: Bool)
}
