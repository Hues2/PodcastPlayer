//
//  PodcastListViewModelTests.swift
//  PodcastPlayerTests
//
//  Created by Greg Ross on 27/04/2026.
//

import Testing
import Foundation
import Factory
import PodcastPlayerNetworkingKit
@testable import PodcastPlayer

// MARK: - Mock Network Service
private final class MockNetworkService: NetworkService {
    var result: Result<Any, Error> = .success(PodcastListDTO(results: []))

    func perform<R: NetworkRequest>(_ request: R) async throws -> R.Response {
        switch result {
        case .success(let value):
            return value as! R.Response
        case .failure(let error):
            throw error
        }
    }
}

// MARK: - Tests
@MainActor
@Suite("PodcastListViewModel", .serialized)
struct PodcastListViewModelTests {
    private let mockNetworkService: MockNetworkService
    private let viewModel: PodcastListViewModel

    init() {
        let mock = MockNetworkService()
        self.mockNetworkService = mock
        Container.shared.networkService.reset()
        Container.shared.networkService.register { mock }
        viewModel = PodcastListViewModel()
    }

    // MARK: - Initial State

    @Test func initialStateIsIdle() {
        #expect(viewModel.state.isIdle)
    }

    // MARK: - Successful Fetch

    @Test func fetchPodcastsSetsLoadedState() async {
        let dto = PodcastDTO(
            author: "Author", categoryIds: [1], description: "Desc", id: 1,
            image: nil, languageIso: "en", link: nil, original: nil,
            popularity: 100, rss: nil, seasonal: false, slug: "random-slug",
            title: "Test Podcast", type: "episodic"
        )

        let dto2 = PodcastDTO(
            author: "Author 2", categoryIds: nil, description: "Desc", id: 2,
            image: nil, languageIso: "esp", link: nil, original: nil,
            popularity: 100, rss: nil, seasonal: false, slug: "random-slug-2",
            title: "Test Podcast 2", type: "episodic"
        )

        mockNetworkService.result = .success(PodcastListDTO(results: [dto, dto2]))

        await viewModel.fetchPodcasts()

        guard case .loaded(let model) = viewModel.state else {
            Issue.record("Expected loaded state")
            return
        }
        #expect(model.podcastsByCategory[1]?.count == 1)
        #expect(model.podcastsByCategory[1]?.first?.title == "Test Podcast")
        #expect(model.featured != nil)
    }

    // MARK: - Empty Response

    @Test func fetchPodcastsWithEmptyResultsSetsError() async {
        mockNetworkService.result = .success(PodcastListDTO(results: []))

        await viewModel.fetchPodcasts()

        guard case .error(let error) = viewModel.state else {
            Issue.record("Expected error state")
            return
        }
        #expect(error == .noPodcastsAvailable)
    }

    @Test func fetchPodcastsWithNilResultsSetsError() async {
        mockNetworkService.result = .success(PodcastListDTO(results: nil))

        await viewModel.fetchPodcasts()

        guard case .error(let error) = viewModel.state else {
            Issue.record("Expected error state")
            return
        }
        #expect(error == .noPodcastsAvailable)
    }

    // MARK: - Network Error

    @Test func fetchPodcastsWithNetworkErrorSetsDefaultError() async {
        mockNetworkService.result = .failure(URLError(.notConnectedToInternet))

        await viewModel.fetchPodcasts()

        guard case .error(let error) = viewModel.state else {
            Issue.record("Expected error state")
            return
        }
        #expect(error == .default)
    }

    @Test func fetchPodcastsWithAppErrorPreservesAppError() async {
        mockNetworkService.result = .failure(AppError.noPodcastsAvailable)

        await viewModel.fetchPodcasts()

        guard case .error(let error) = viewModel.state else {
            Issue.record("Expected error state")
            return
        }
        #expect(error == .noPodcastsAvailable)
    }

    // MARK: - Guard Against Duplicate Fetches

    @Test func fetchPodcastsDoesNotRefetchWhenLoaded() async {
        let dto = PodcastDTO(
            author: nil, categoryIds: [1], description: nil, id: 1,
            image: nil, languageIso: nil, link: nil, original: nil,
            popularity: nil, rss: nil, seasonal: nil, slug: nil,
            title: "First", type: nil
        )
        mockNetworkService.result = .success(PodcastListDTO(results: [dto]))
        await viewModel.fetchPodcasts()

        // Change the mock response — this should NOT be fetched
        mockNetworkService.result = .success(PodcastListDTO(results: []))
        await viewModel.fetchPodcasts()

        guard case .loaded(let model) = viewModel.state else {
            Issue.record("Expected loaded state to persist")
            return
        }
        #expect(model.podcastsByCategory[1]?.first?.title == "First")
    }

    @Test func fetchPodcastsRetriesFromErrorState() async {
        mockNetworkService.result = .failure(URLError(.timedOut))
        await viewModel.fetchPodcasts()
        #expect(viewModel.state.isError)

        // Retry with a successful response
        let dto = PodcastDTO(
            author: nil, categoryIds: [1], description: nil, id: 1,
            image: nil, languageIso: nil, link: nil, original: nil,
            popularity: nil, rss: nil, seasonal: nil, slug: nil,
            title: "Retried", type: nil
        )
        mockNetworkService.result = .success(PodcastListDTO(results: [dto]))
        await viewModel.fetchPodcasts()

        guard case .loaded(let model) = viewModel.state else {
            Issue.record("Expected loaded state after retry")
            return
        }
        #expect(model.podcastsByCategory[1]?.first?.title == "Retried")
    }

    // MARK: - Category Grouping

    @Test func podcastsAreGroupedByCategory() async {
        let dto1 = PodcastDTO(
            author: nil, categoryIds: [1, 2], description: nil, id: 1,
            image: nil, languageIso: nil, link: nil, original: nil,
            popularity: nil, rss: nil, seasonal: nil, slug: nil,
            title: "Multi-Category", type: nil
        )
        let dto2 = PodcastDTO(
            author: nil, categoryIds: [2], description: nil, id: 2,
            image: nil, languageIso: nil, link: nil, original: nil,
            popularity: nil, rss: nil, seasonal: nil, slug: nil,
            title: "Single-Category", type: nil
        )
        mockNetworkService.result = .success(PodcastListDTO(results: [dto1, dto2]))

        await viewModel.fetchPodcasts()

        guard case .loaded(let model) = viewModel.state else {
            Issue.record("Expected loaded state")
            return
        }
        #expect(model.podcastsByCategory[1]?.count == 1)
        #expect(model.podcastsByCategory[2]?.count == 2)
    }

    // MARK: - Nil Category IDs

    @Test func podcastsWithNilCategoryIdsGiveError() async {
        let dto = PodcastDTO(
            author: nil, categoryIds: nil, description: nil, id: 1,
            image: nil, languageIso: nil, link: nil, original: nil,
            popularity: nil, rss: nil, seasonal: nil, slug: nil,
            title: "No Categories", type: nil
        )
        mockNetworkService.result = .success(PodcastListDTO(results: [dto]))

        await viewModel.fetchPodcasts()

        guard case .error(let error) = viewModel.state else {
            Issue.record("Expected error state")
            return
        }
        
        #expect(error == .noPodcastsAvailable)
    }

    // MARK: - ViewState Helpers

    @Test func viewStateIsIdleReturnsCorrectly() {
        #expect(PodcastListViewModel.ViewState.idle.isIdle == true)
        #expect(PodcastListViewModel.ViewState.loading.isIdle == false)
        #expect(PodcastListViewModel.ViewState.error(.default).isIdle == false)
    }

    @Test func viewStateIsErrorReturnsCorrectly() {
        #expect(PodcastListViewModel.ViewState.error(.default).isError == true)
        #expect(PodcastListViewModel.ViewState.idle.isError == false)
        #expect(PodcastListViewModel.ViewState.loading.isError == false)
    }
}
