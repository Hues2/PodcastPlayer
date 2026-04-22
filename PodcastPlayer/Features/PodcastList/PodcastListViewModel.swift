//
//  PodcastListViewModel.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 21/04/2026.
//

import Foundation
import PodcastPlayerNetworkingKit
import Factory

@Observable
final class PodcastListViewModel {
    private(set) var state: ViewState = .idle

    // Dependencies
    @ObservationIgnored @Injected(\.networkService) private var networkService

    func fetchPodcasts() async {
        guard case .idle = state else { return }
        state = .loading
        do {
            let response = try await networkService.perform(FetchPodcastListRequest())
            let podcasts = response.results?.compactMap { PodcastUIModel($0) } ?? []
            
            guard !podcasts.isEmpty else { throw AppError.noPodcastsAvailable }

            let listModel = LoadedUIModel(
                featured: podcasts.randomElement(),
                podcasts: podcasts
            )
            state = .loaded(listModel)
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
        case loaded(LoadedUIModel)
    }

    struct LoadedUIModel {
        let featured: PodcastUIModel?
        let podcasts: [PodcastUIModel]
    }
}

// MARK: - Network Requests
extension PodcastListViewModel {
    struct FetchPodcastListRequest: NetworkRequest {
        typealias Response = PodcastListDTO

        var path: String { "toplist" }
        var method: HTTPMethod { .get }
    }
}
