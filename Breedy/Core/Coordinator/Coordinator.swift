//
//  Coordinator.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

public protocol Coordinator: AnyObject {
  func start()
  func start(with option: DeepLinkOption)
}
