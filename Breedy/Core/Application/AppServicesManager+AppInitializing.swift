//
//  AppServicesManager+AppInitializing.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import UIKit

extension PluggableApplicationDelegate {

    open func application(_ application: UIApplication, // swiftlint:disable:next line_length
                          willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        var result = false
        for service in _services {
            if service.application?(application, willFinishLaunchingWithOptions: launchOptions) ?? false {
                result = true
            }
        }
        return result
    }

    open func application(_ application: UIApplication, // swiftlint:disable:next line_length
                          didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        var result = false
        for service in _services {
            if service.application?(application, didFinishLaunchingWithOptions: launchOptions) ?? false {
                result = true
            }
        }
        return result
    }

    open func applicationDidFinishLaunching(_ application: UIApplication) {
        _services.forEach { $0.applicationDidFinishLaunching?(application) }
    }
}
