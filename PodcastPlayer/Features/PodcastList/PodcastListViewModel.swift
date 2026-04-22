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
        guard state.isIdle || state.isError else { return }
        state = .loading
        do {
            let response = try await networkService.perform(FetchPodcastListRequest())
            let podcasts = response.results?.compactMap { PodcastUIModel($0) } ?? []
            
            guard !podcasts.isEmpty else { throw AppError.noPodcastsAvailable }

            let listModel = LoadedUIModel(
                // Featured podcast would be fetched from API - but it's not an option
                featured: podcasts.randomElement(),
                podcastsByCategory: groupByCategory(podcasts)
            )
            state = .loaded(listModel)
        } catch {
            let appError: AppError = error as? AppError ?? .default
            state = .error(appError)
        }
    }
}

// MARK: - Helpers
private extension PodcastListViewModel {
    func groupByCategory(_ podcasts: [PodcastUIModel]) -> [Int: [PodcastUIModel]] {
        var categoryMap: [Int: [PodcastUIModel]] = [:]
        for podcast in podcasts {
            for categoryId in podcast.categoryIds ?? [] {
                categoryMap[categoryId, default: []].append(podcast)
            }
        }
        return categoryMap
    }
}

// MARK: - View State
extension PodcastListViewModel {
    enum ViewState {
        case idle
        case loading
        case error(AppError)
        case loaded(LoadedUIModel)

        var isIdle: Bool {
            if case .idle = self { return true }
            return false
        }

        var isError: Bool {
            if case .error = self { return true }
            return false
        }
    }

    struct LoadedUIModel {
        let featured: PodcastUIModel?
        let podcastsByCategory: [Int: [PodcastUIModel]]
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
