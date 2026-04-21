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
        self { NetworkServiceImpl(baseURL: "https://the-podcasts.fly.dev/v1/") }
            .singleton
    }
}
