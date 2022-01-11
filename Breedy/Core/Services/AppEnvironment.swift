//
//  AppEnvironment.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import UIKit

struct AppEnvironment {

    fileprivate static var stack: [Environment] = [.current]

    // The most recent environment on the stack.
    public static var current: Environment! {
        return stack.last
    }

    // Replace the current environment with a new environment.
    public static func replaceCurrentEnvironment(_ env: Environment) {
        self.pushEnvironment(env)
    }

    public static func pushEnvironment(_ env: Environment) {
        self.stack.insert(env, at: 0)
    }
}

extension AppEnvironment {

    public static var lookupService: LookupService {
        current.lookupService
    }

    public static var profileServices: ProfileServices {
        return current.profileServices
    }

    public static var baseURL: URL {
        current.baseURL
    }
}
