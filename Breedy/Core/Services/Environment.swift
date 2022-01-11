//
//  Environment.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import Foundation

public struct Environment {

    static let current = Environment()

    let lookupService: LookupService
    let profileServices: ProfileServices
    let baseURL: URL

    init(lookupService: LookupService = LookupServiceImpl(),
         profileServices: ProfileServices = ProfileServicesImpl(),
         baseURL: URL = URL(string: "https://dog.ceo/api")!) {
        self.baseURL = baseURL
        self.lookupService = lookupService
        self.profileServices = profileServices
    }
}
