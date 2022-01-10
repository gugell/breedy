//
//  MoyaProviderFactory.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import Foundation
import Moya

enum _MoyaProvider {
    static func of<Target: TargetType>(ofType type: Target.Type) -> MoyaProvider<Target> {
        return MoyaProvider<Target>(plugins: [
            NetworkLoggerPlugin.verbose
        ])
    }
}
