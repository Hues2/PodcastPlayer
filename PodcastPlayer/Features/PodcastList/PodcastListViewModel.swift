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
    private(set) var state: ViewState = .idle
    private let networkService: NetworkService

    init(networkService: NetworkService = NetworkServiceImpl()) {
        self.networkService = networkService
    }

    func fetchPodcasts() async {
        guard case .idle = state else { return }
        state = .loading
        do {
            let response = try await networkService.perform(FetchPodcastListRequest())
            let podcasts = response.results?.compactMap { PodcastUIModel($0) } ?? []
            state = .loaded(podcasts)
        } catch {
            state = .error(error)
        }
    }
}

// MARK: - View State
extension PodcastListViewModel {
    enum ViewState {
        case idle
        case loading
        case error(Error)
        case loaded([PodcastUIModel])
    }
}

// MARK: - Network Requests
extension PodcastListViewModel {
    struct FetchPodcastListRequest: NetworkRequest {
        typealias Response = PodcastListDTO

        var baseURL: URL { URL(string: "https://the-podcasts.fly.dev")! }
        var path: String { "/v1/toplist" }
        var method: HTTPMethod { .get }
    }
}
