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
    let podcast: PodcastUIModel
    
    private(set) var episodeListState: EpisodeListState = .idle

    // Dependencies
    @ObservationIgnored @Injected(\.networkService) private var networkService

    init(podcast: PodcastUIModel) {
        self.podcast = podcast
    }

    func fetchEpisodes() async {
        guard episodeListState.isIdle || episodeListState.isError else { return }
        episodeListState = .loading

        do {
            let response = try await networkService.perform(FetchEpisodesRequest(podcastId: podcast.id))
            let episodes: [EpisodeUIModel] = response.results?.compactMap {
                var episodeUIModel = EpisodeUIModel($0)
                episodeUIModel?.podcastTitle = podcast.title
                episodeUIModel?.podcastImageURL = podcast.imageURL
                return episodeUIModel
            } ?? []

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
