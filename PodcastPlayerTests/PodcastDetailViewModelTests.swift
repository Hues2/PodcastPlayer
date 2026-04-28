//
//  PodcastDetailViewModelTests.swift
//  PodcastPlayerTests
//

import Testing
import Foundation
import Factory
import PodcastPlayerNetworkingKit
@testable import PodcastPlayer

// MARK: - Mock Network Service
private final class MockNetworkService: NetworkService {
    var result: Result<Any, Error> = .success(EpisodeListDTO(results: []))

    func perform<R: NetworkRequest>(_ request: R) async throws -> R.Response {
        switch result {
        case .success(let value):
            guard let typed = value as? R.Response else {
                throw AppError.default
            }
            return typed
        case .failure(let error):
            throw error
        }
    }
}

// MARK: - Helpers
private extension PodcastDetailViewModelTests {
    static let testPodcast = PodcastUIModel(
        id: 42,
        title: "Test Podcast",
        author: "Author",
        categoryIds: [1],
        description: "A podcast",
        imageURL: URL(string: "https://example.com/image.png"),
        languageIso: "en",
        link: nil,
        popularity: 100,
        rss: nil,
        seasonal: false,
        type: "episodic"
    )

    static let testPodcastDTO = PodcastDTO(
        author: "Author", categoryIds: [1], description: "A podcast",
        id: 42, image: nil, languageIso: "en", link: nil,
        original: nil, popularity: 100, rss: nil,
        seasonal: false, slug: nil, title: "Test Podcast", type: "episodic"
    )

    static let testEpisodeDTO = EpisodeDTO(
        id: 1, title: "Episode 1", description: "First episode",
        duration: 3600, encoded: nil, episode: 1, exclusive: nil,
        mimeType: nil, podcastId: 42, published: 1700000000,
        season: 1, slug: nil, type: "full",
        url: "https://example.com/episode.mp3"
    )

    static let testEpisodeDTO2 = EpisodeDTO(
        id: 2, title: "Episode 2", description: "Second episode",
        duration: 1800, encoded: nil, episode: 2, exclusive: nil,
        mimeType: nil, podcastId: 42, published: 1700100000,
        season: 1, slug: nil, type: "full",
        url: "https://example.com/episode2.mp3"
    )
}

// MARK: - Tests
@MainActor
@Suite("PodcastDetailViewModel", .serialized)
struct PodcastDetailViewModelTests {
    private let mockNetworkService: MockNetworkService

    init() {
        let mock = MockNetworkService()
        self.mockNetworkService = mock
        Container.shared.networkService.reset()
        Container.shared.networkService.register { mock }
    }

    // MARK: - Init with Podcast

    @Test func initWithPodcastSetsLoadedState() {
        let viewModel = PodcastDetailViewModel(podcast: Self.testPodcast)
        #expect(viewModel.podcast?.id == 42)
        guard case .loaded(let podcast) = viewModel.podcastState else {
            Issue.record("Expected loaded podcast state")
            return
        }
        #expect(podcast.title == "Test Podcast")
    }

    @Test func initWithPodcastStartsWithIdleEpisodeState() {
        let viewModel = PodcastDetailViewModel(podcast: Self.testPodcast)
        #expect(viewModel.episodeListState.isIdle)
    }

    // MARK: - Init with ID (Deeplink)

    @Test func initWithIdStartsWithIdleStates() {
        let viewModel = PodcastDetailViewModel(id: 42)
        #expect(viewModel.podcast == nil)
        #expect(viewModel.podcastState.isIdle)
        #expect(viewModel.episodeListState.isIdle)
    }

    // MARK: - Fetch Episodes (Standard Navigation)

    @Test func fetchDataWithPodcastFetchesEpisodes() async {
        let viewModel = PodcastDetailViewModel(podcast: Self.testPodcast)
        mockNetworkService.result = .success(EpisodeListDTO(results: [Self.testEpisodeDTO, Self.testEpisodeDTO2]))

        await viewModel.fetchData()

        guard case .loaded(let episodes) = viewModel.episodeListState else {
            Issue.record("Expected loaded episode state")
            return
        }
        #expect(episodes.count == 2)
        #expect(episodes[0].title == "Episode 1")
        #expect(episodes[1].title == "Episode 2")
    }

    @Test func fetchedEpisodesHavePodcastMetadata() async {
        let viewModel = PodcastDetailViewModel(podcast: Self.testPodcast)
        mockNetworkService.result = .success(EpisodeListDTO(results: [Self.testEpisodeDTO]))

        await viewModel.fetchData()

        guard case .loaded(let episodes) = viewModel.episodeListState else {
            Issue.record("Expected loaded episode state")
            return
        }
        #expect(episodes[0].podcastTitle == "Test Podcast")
        #expect(episodes[0].podcastImageURL == URL(string: "https://example.com/image.png"))
    }

    @Test func fetchEpisodesWithEmptyResultsSetsError() async {
        let viewModel = PodcastDetailViewModel(podcast: Self.testPodcast)
        mockNetworkService.result = .success(EpisodeListDTO(results: []))

        await viewModel.fetchData()

        guard case .error(let error) = viewModel.episodeListState else {
            Issue.record("Expected error episode state")
            return
        }
        #expect(error == .noEpisodesAvailable)
    }

    @Test func fetchEpisodesWithNilResultsSetsError() async {
        let viewModel = PodcastDetailViewModel(podcast: Self.testPodcast)
        mockNetworkService.result = .success(EpisodeListDTO(results: nil))

        await viewModel.fetchData()

        guard case .error(let error) = viewModel.episodeListState else {
            Issue.record("Expected error episode state")
            return
        }
        #expect(error == .noEpisodesAvailable)
    }

    @Test func fetchEpisodesWithNetworkErrorSetsDefaultError() async {
        let viewModel = PodcastDetailViewModel(podcast: Self.testPodcast)
        mockNetworkService.result = .failure(URLError(.notConnectedToInternet))

        await viewModel.fetchData()

        guard case .error(let error) = viewModel.episodeListState else {
            Issue.record("Expected error episode state")
            return
        }
        #expect(error == .default)
    }

    @Test func fetchEpisodesWithAppErrorPreservesAppError() async {
        let viewModel = PodcastDetailViewModel(podcast: Self.testPodcast)
        mockNetworkService.result = .failure(AppError.noEpisodesAvailable)

        await viewModel.fetchData()

        guard case .error(let error) = viewModel.episodeListState else {
            Issue.record("Expected error episode state")
            return
        }
        #expect(error == .noEpisodesAvailable)
    }

    @Test func fetchEpisodesDoesNotRefetchWhenLoaded() async {
        let viewModel = PodcastDetailViewModel(podcast: Self.testPodcast)
        mockNetworkService.result = .success(EpisodeListDTO(results: [Self.testEpisodeDTO]))
        await viewModel.fetchData()

        // Change mock — should NOT be fetched
        mockNetworkService.result = .success(EpisodeListDTO(results: []))
        await viewModel.fetchData()

        guard case .loaded(let episodes) = viewModel.episodeListState else {
            Issue.record("Expected loaded episode state to persist")
            return
        }
        #expect(episodes.count == 1)
        #expect(episodes[0].title == "Episode 1")
    }

    @Test func fetchEpisodesRetriesFromErrorState() async {
        let viewModel = PodcastDetailViewModel(podcast: Self.testPodcast)
        mockNetworkService.result = .failure(URLError(.timedOut))
        await viewModel.fetchData()
        #expect(viewModel.episodeListState.isError)

        mockNetworkService.result = .success(EpisodeListDTO(results: [Self.testEpisodeDTO]))
        await viewModel.fetchData()

        guard case .loaded(let episodes) = viewModel.episodeListState else {
            Issue.record("Expected loaded episode state after retry")
            return
        }
        #expect(episodes[0].title == "Episode 1")
    }

    @Test func fetchEpisodesSkipsEpisodesWithNilId() async {
        let viewModel = PodcastDetailViewModel(podcast: Self.testPodcast)
        let invalidDTO = EpisodeDTO(
            id: nil, title: "Bad", description: nil,
            duration: nil, encoded: nil, episode: nil, exclusive: nil,
            mimeType: nil, podcastId: nil, published: nil,
            season: nil, slug: nil, type: nil, url: nil
        )
        mockNetworkService.result = .success(EpisodeListDTO(results: [Self.testEpisodeDTO, invalidDTO]))

        await viewModel.fetchData()

        guard case .loaded(let episodes) = viewModel.episodeListState else {
            Issue.record("Expected loaded episode state")
            return
        }
        #expect(episodes.count == 1)
    }

    // MARK: - Fetch Podcast (Deeplink)

    @Test func fetchDataWithIdFetchesPodcast() async {
        let viewModel = PodcastDetailViewModel(id: 42)
        mockNetworkService.result = .success(SinglePodcastDTO(podcast: Self.testPodcastDTO))

        await viewModel.fetchData()

        guard case .loaded(let podcast) = viewModel.podcastState else {
            Issue.record("Expected loaded podcast state")
            return
        }
        #expect(podcast.id == 42)
        #expect(podcast.title == "Test Podcast")
    }

    @Test func fetchPodcastWithNilPodcastSetsError() async {
        let viewModel = PodcastDetailViewModel(id: 42)
        mockNetworkService.result = .success(SinglePodcastDTO(podcast: nil))

        await viewModel.fetchData()

        guard case .error(let error) = viewModel.podcastState else {
            Issue.record("Expected error podcast state")
            return
        }
        #expect(error == .podcastNotFound)
    }

    @Test func fetchPodcastWithNilIdInDTOSetsError() async {
        let viewModel = PodcastDetailViewModel(id: 42)
        let badDTO = PodcastDTO(
            author: nil, categoryIds: nil, description: nil,
            id: nil, image: nil, languageIso: nil, link: nil,
            original: nil, popularity: nil, rss: nil,
            seasonal: nil, slug: nil, title: nil, type: nil
        )
        mockNetworkService.result = .success(SinglePodcastDTO(podcast: badDTO))

        await viewModel.fetchData()

        guard case .error(let error) = viewModel.podcastState else {
            Issue.record("Expected error podcast state")
            return
        }
        #expect(error == .podcastNotFound)
    }

    @Test func fetchPodcastWithNetworkErrorSetsError() async {
        let viewModel = PodcastDetailViewModel(id: 42)
        mockNetworkService.result = .failure(URLError(.notConnectedToInternet))

        await viewModel.fetchData()

        guard case .error(let error) = viewModel.podcastState else {
            Issue.record("Expected error podcast state")
            return
        }
        #expect(error == .podcastNotFound)
    }

    @Test func fetchPodcastWithAppErrorPreservesAppError() async {
        let viewModel = PodcastDetailViewModel(id: 42)
        mockNetworkService.result = .failure(AppError.podcastNotFound)

        await viewModel.fetchData()

        guard case .error(let error) = viewModel.podcastState else {
            Issue.record("Expected error podcast state")
            return
        }
        #expect(error == .podcastNotFound)
    }

    @Test func fetchPodcastDoesNotRefetchWhenLoaded() async {
        let viewModel = PodcastDetailViewModel(id: 42)
        mockNetworkService.result = .success(SinglePodcastDTO(podcast: Self.testPodcastDTO))
        await viewModel.fetchData()

        // Change mock — podcast fetch should NOT happen again
        mockNetworkService.result = .success(SinglePodcastDTO(podcast: nil))
        await viewModel.fetchData()

        guard case .loaded(let podcast) = viewModel.podcastState else {
            Issue.record("Expected loaded podcast state to persist")
            return
        }
        #expect(podcast.title == "Test Podcast")
    }

    @Test func fetchPodcastRetriesFromErrorState() async {
        let viewModel = PodcastDetailViewModel(id: 42)
        mockNetworkService.result = .failure(URLError(.timedOut))
        await viewModel.fetchData()
        #expect(viewModel.podcastState.isError)

        mockNetworkService.result = .success(SinglePodcastDTO(podcast: Self.testPodcastDTO))
        await viewModel.fetchData()

        guard case .loaded(let podcast) = viewModel.podcastState else {
            Issue.record("Expected loaded podcast state after retry")
            return
        }
        #expect(podcast.title == "Test Podcast")
    }

    // MARK: - Share URL

    @Test func getShareURLReturnsURLWhenPodcastExists() {
        let viewModel = PodcastDetailViewModel(podcast: Self.testPodcast)
        let url = viewModel.getShareURL()
        #expect(url != nil)
    }

    // MARK: - State Helpers

    @Test func podcastStateHelpers() {
        #expect(PodcastDetailViewModel.PodcastState.idle.isIdle == true)
        #expect(PodcastDetailViewModel.PodcastState.loading.isIdle == false)
        #expect(PodcastDetailViewModel.PodcastState.loading.isLoading == true)
        #expect(PodcastDetailViewModel.PodcastState.idle.isLoading == false)
        #expect(PodcastDetailViewModel.PodcastState.error(.default).isError == true)
        #expect(PodcastDetailViewModel.PodcastState.idle.isError == false)
    }

    @Test func episodeListStateHelpers() {
        #expect(PodcastDetailViewModel.EpisodeListState.idle.isIdle == true)
        #expect(PodcastDetailViewModel.EpisodeListState.loading.isIdle == false)
        #expect(PodcastDetailViewModel.EpisodeListState.error(.default).isError == true)
        #expect(PodcastDetailViewModel.EpisodeListState.idle.isError == false)
    }
}
