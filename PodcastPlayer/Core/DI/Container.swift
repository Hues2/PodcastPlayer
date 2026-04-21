//
//  Container.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 21/04/2026.
//

import Foundation
import Factory
import PodcastPlayerNetworkingKit

extension Container {
    var networkService: Factory<NetworkService> {
        let baseUrl: String = Utils.infoPlistValue(for: "API_BASE_URL") ?? ""
        return self { NetworkServiceImpl(baseURL: baseUrl) }.singleton
    }
}
