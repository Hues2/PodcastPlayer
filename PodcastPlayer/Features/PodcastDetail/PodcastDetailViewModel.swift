//
//  PodcastDetailViewModel.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 22/04/2026.
//

import Foundation
import PodcastPlayerNetworkingKit
import Factory

@Observable
final class PodcastDetailViewModel {
    private(set) var episodeListState: EpisodeListState = .idle

    // Dependencies
    @ObservationIgnored @Injected(\.networkService) private var networkService

    private let podcastId: Int

    init(podcastId: Int) {
        self.podcastId = podcastId
    }

    func fetchEpisodes() async {
        guard episodeListState.isIdle || episodeListState.isError else { return }
        episodeListState = .loading

        do {
            let response = try await networkService.perform(FetchEpisodesRequest(podcastId: podcastId))
            let episodes = response.results?.compactMap { EpisodeUIModel($0) } ?? []

            // TODO: No episodes available - not podcasts
            guard !episodes.isEmpty else { throw AppError.noPodcastsAvailable }

            episodeListState = .loaded(episodes)
        } catch {
            let appError: AppError = error as? AppError ?? .default
            episodeListState = .error(appError)
        }
    }
}

// MARK: - Episode List State
extension PodcastDetailViewModel {
    enum EpisodeListState {
        case idle
        case loading
        case error(AppError)
        case loaded([EpisodeUIModel])

        var isIdle: Bool {
            if case .idle = self { return true }
            return false
        }

        var isError: Bool {
            if case .error = self { return true }
            return false
        }
    }
}

// MARK: - Network Requests
extension PodcastDetailViewModel {
    struct FetchEpisodesRequest: NetworkRequest {
        typealias Response = EpisodeListDTO

        let podcastId: Int

        var path: String { "podcasts/\(podcastId)/episodes" }
        var method: HTTPMethod { .get }
    }
}
