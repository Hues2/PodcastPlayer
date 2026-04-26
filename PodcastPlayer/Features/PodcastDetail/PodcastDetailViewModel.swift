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
    private(set) var podcast: PodcastUIModel?
    private(set) var podcastState: PodcastState = .idle
    private(set) var episodeListState: EpisodeListState = .idle

    private let podcastId: Int

    // Dependencies
    @ObservationIgnored @Injected(\.networkService) private var networkService

    init(podcast: PodcastUIModel) {
        self.podcastId = podcast.id
        self.podcast = podcast
        self.podcastState = .loaded(podcast)
    }

    init(id: Int) {
        self.podcastId = id
    }

    func fetchPodcast() async {
        guard podcastState.isIdle || podcastState.isError else { return }
        podcastState = .loading

        do {
            let response = try await networkService.perform(FetchPodcastRequest(podcastId: podcastId))
            guard let podcast = PodcastUIModel(response) else { throw AppError.default }
            self.podcast = podcast
            podcastState = .loaded(podcast)
            await fetchEpisodes()
        } catch {
            let appError: AppError = error as? AppError ?? .default
            podcastState = .error(appError)
        }
    }

    func fetchEpisodes() async {
        guard let podcast else { return }
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

            guard !episodes.isEmpty else { throw AppError.noEpisodesAvailable }

            episodeListState = .loaded(episodes)
        } catch {
            let appError: AppError = error as? AppError ?? .default
            episodeListState = .error(appError)
        }
    }
}

// MARK: - Podcast State
extension PodcastDetailViewModel {
    enum PodcastState {
        case idle
        case loading
        case error(AppError)
        case loaded(PodcastUIModel)

        var isIdle: Bool {
            if case .idle = self { return true }
            return false
        }

        var isError: Bool {
            if case .error = self { return true }
            return false
        }

        var isLoading: Bool {
            if case .loading = self { return true }
            return false
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
    struct FetchPodcastRequest: NetworkRequest {
        typealias Response = SinglePodcastDTO

        let podcastId: Int

        var path: String { "podcasts/\(podcastId)" }
        var method: HTTPMethod { .get }
    }

    struct FetchEpisodesRequest: NetworkRequest {
        typealias Response = EpisodeListDTO

        let podcastId: Int

        var path: String { "podcasts/\(podcastId)/episodes" }
        var method: HTTPMethod { .get }
    }
}
