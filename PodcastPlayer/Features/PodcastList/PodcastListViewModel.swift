//
//  PodcastListViewModel.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 21/04/2026.
//

import Foundation
import PodcastPlayerNetworkingKit

@Observable
final class PodcastListViewModel {
    private let networkService: NetworkService

    init(networkService: NetworkService = NetworkServiceImpl()) {
        self.networkService = networkService
    }
}
