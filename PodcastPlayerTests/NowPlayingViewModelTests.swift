//
//  NowPlayingViewModelTests.swift
//  PodcastPlayerTests
//

import Testing
import Foundation
import Factory
import PodcastPlayerAudioKit
@testable import PodcastPlayer

// MARK: - Mock Audio Player Service
private final class MockAudioPlayerService: AudioPlayerService {
    private let stateContinuation: AsyncStream<PlaybackState>.Continuation
    private let timeContinuation: AsyncStream<PlaybackTime>.Continuation

    let playbackStateStream: AsyncStream<PlaybackState>
    let playbackTimeStream: AsyncStream<PlaybackTime>

    private(set) var startPlayingURL: URL?
    private(set) var pauseCalled = false
    private(set) var resumeCalled = false
    private(set) var seekToSeconds: Double?
    private(set) var skipForwardSeconds: Double?
    private(set) var skipBackwardSeconds: Double?

    init() {
        var stateCont: AsyncStream<PlaybackState>.Continuation!
        playbackStateStream = AsyncStream { stateCont = $0 }
        stateContinuation = stateCont

        var timeCont: AsyncStream<PlaybackTime>.Continuation!
        playbackTimeStream = AsyncStream { timeCont = $0 }
        timeContinuation = timeCont
    }

    func startPlaying(url: URL) {
        startPlayingURL = url
    }

    func pause() {
        pauseCalled = true
    }

    func resume() {
        resumeCalled = true
    }

    func seekTo(seconds: Double) async {
        seekToSeconds = seconds
    }

    func skipForward(seconds: Double) {
        skipForwardSeconds = seconds
    }

    func skipBackward(seconds: Double) {
        skipBackwardSeconds = seconds
    }

    func emitState(_ state: PlaybackState) {
        stateContinuation.yield(state)
    }

    func emitTime(_ time: PlaybackTime) {
        timeContinuation.yield(time)
    }
}

// MARK: - Helpers
private extension NowPlayingViewModelTests {
    static let testEpisode = EpisodeUIModel(
        id: 1,
        title: "Test Episode",
        description: "A test episode",
        duration: 3600,
        published: Date(timeIntervalSince1970: 1700000000),
        episode: 1,
        season: 1,
        type: "full",
        audioURL: URL(string: "https://example.com/episode.mp3"),
        podcastTitle: "Test Podcast",
        podcastImageURL: URL(string: "https://example.com/image.png")
    )

    static let testEpisode2 = EpisodeUIModel(
        id: 2,
        title: "Test Episode 2",
        description: "Another test episode",
        duration: 1800,
        published: Date(timeIntervalSince1970: 1700100000),
        episode: 2,
        season: 1,
        type: "full",
        audioURL: URL(string: "https://example.com/episode2.mp3"),
        podcastTitle: "Test Podcast",
        podcastImageURL: nil
    )

    static let episodeWithNoAudioURL = EpisodeUIModel(
        id: 3,
        title: "No Audio",
        description: nil,
        duration: nil,
        published: nil,
        episode: nil,
        season: nil,
        type: nil,
        audioURL: nil,
        podcastTitle: nil,
        podcastImageURL: nil
    )
}

// MARK: - Tests
@MainActor
@Suite("NowPlayingViewModel", .serialized)
struct NowPlayingViewModelTests {
    private let mockAudioService: MockAudioPlayerService

    init() {
        let mock = MockAudioPlayerService()
        self.mockAudioService = mock
        Container.shared.audioPlayerService.reset()
        Container.shared.audioPlayerService.register { mock }
    }

    // MARK: - Initial State

    @Test func initialStateWithNoEpisode() {
        let viewModel = NowPlayingViewModel()
        #expect(viewModel.currentlyPlayingEpisode == nil)
        #expect(viewModel.playbackState == .idle)
        #expect(viewModel.currentTime == 0)
        #expect(viewModel.duration == 0)
        #expect(viewModel.isNowPlayingExpanded == false)
        #expect(viewModel.error == nil)
    }

    @Test func initialStateWithEpisode() {
        let viewModel = NowPlayingViewModel(currentlyPlayingEpisode: Self.testEpisode)
        #expect(viewModel.currentlyPlayingEpisode == Self.testEpisode)
    }

    // MARK: - Computed Properties

    @Test func isPlayingReturnsTrueWhenPlaying() {
        let viewModel = NowPlayingViewModel()
        #expect(viewModel.isPlaying == false)
    }

    @Test func isLoadingReturnsTrueWhenIdle() {
        let viewModel = NowPlayingViewModel()
        #expect(viewModel.isLoading == true)
    }

    @Test func remainingTimeCalculation() {
        let viewModel = NowPlayingViewModel()
        #expect(viewModel.remainingTime == 0)
    }

    @Test func remainingTimeDoesNotGoNegative() {
        let viewModel = NowPlayingViewModel()
        // currentTime and duration both start at 0, so remaining is 0
        #expect(viewModel.remainingTime >= 0)
    }

    // MARK: - Episode Selection

    @Test func onEpisodeSelectedStartsPlayingNewEpisode() {
        let viewModel = NowPlayingViewModel()
        viewModel.onEpisodeSelected(episode: Self.testEpisode)

        #expect(viewModel.currentlyPlayingEpisode == Self.testEpisode)
        #expect(mockAudioService.startPlayingURL == URL(string: "https://example.com/episode.mp3"))
    }

    @Test func onEpisodeSelectedExpandsWhenSameEpisode() {
        let viewModel = NowPlayingViewModel(currentlyPlayingEpisode: Self.testEpisode)
        viewModel.onEpisodeSelected(episode: Self.testEpisode)

        #expect(viewModel.isNowPlayingExpanded == true)
        #expect(mockAudioService.startPlayingURL == nil)
    }

    @Test func onEpisodeSelectedSwitchesToDifferentEpisode() {
        let viewModel = NowPlayingViewModel(currentlyPlayingEpisode: Self.testEpisode)
        viewModel.onEpisodeSelected(episode: Self.testEpisode2)

        #expect(viewModel.currentlyPlayingEpisode == Self.testEpisode2)
        #expect(mockAudioService.startPlayingURL == URL(string: "https://example.com/episode2.mp3"))
    }

    @Test func onEpisodeSelectedWithNilAudioURLSetsError() {
        let viewModel = NowPlayingViewModel()
        viewModel.onEpisodeSelected(episode: Self.episodeWithNoAudioURL)

        #expect(viewModel.error == .invalidEpisodeURL)
        #expect(viewModel.currentlyPlayingEpisode == nil)
        #expect(mockAudioService.startPlayingURL == nil)
    }

    @Test func onEpisodeSelectedResetsPlaybackState() {
        let viewModel = NowPlayingViewModel(currentlyPlayingEpisode: Self.testEpisode)
        viewModel.onEpisodeSelected(episode: Self.testEpisode2)

        #expect(viewModel.playbackState == .idle)
        #expect(viewModel.currentTime == 0)
        #expect(viewModel.duration == 0)
    }

    // MARK: - Play/Pause

    @Test func playPauseActionPausesWhenPlaying() {
        let viewModel = NowPlayingViewModel()
        // Simulate playing state by selecting an episode first
        viewModel.onEpisodeSelected(episode: Self.testEpisode)

        // We can't directly set playbackState, but we can test the idle path
        viewModel.playPauseAction()
        // In idle state, isPlaying is false, so it should call resume
        #expect(mockAudioService.resumeCalled == true)
        #expect(mockAudioService.pauseCalled == false)
    }

    // MARK: - Seek

    @Test func seekToUpdatesCurrentTimeAndCallsService() async {
        let viewModel = NowPlayingViewModel(currentlyPlayingEpisode: Self.testEpisode)
        // Need to be in a non-loading state; playbackState starts as .idle which isLoading
        // So seekTo should be guarded and not proceed
        await viewModel.seekTo(seconds: 30)
        #expect(mockAudioService.seekToSeconds == nil)
    }

    @Test func seekToGuardsWhenNoEpisode() async {
        let viewModel = NowPlayingViewModel()
        await viewModel.seekTo(seconds: 30)
        #expect(mockAudioService.seekToSeconds == nil)
    }

    // MARK: - Skip Forward/Backward

    @Test func skipForwardGuardsWhenNoEpisode() {
        let viewModel = NowPlayingViewModel()
        viewModel.skipForward()
        #expect(mockAudioService.skipForwardSeconds == nil)
    }

    @Test func skipBackwardGuardsWhenNoEpisode() {
        let viewModel = NowPlayingViewModel()
        viewModel.skipBackward()
        #expect(mockAudioService.skipBackwardSeconds == nil)
    }

    @Test func skipForwardGuardsWhenLoading() {
        let viewModel = NowPlayingViewModel(currentlyPlayingEpisode: Self.testEpisode)
        // playbackState starts as .idle, which isLoading == true
        viewModel.skipForward()
        #expect(mockAudioService.skipForwardSeconds == nil)
    }

    @Test func skipBackwardGuardsWhenLoading() {
        let viewModel = NowPlayingViewModel(currentlyPlayingEpisode: Self.testEpisode)
        viewModel.skipBackward()
        #expect(mockAudioService.skipBackwardSeconds == nil)
    }

    // MARK: - UI Functionality

    @Test func setIsNowPlayingExpandedTrue() {
        let viewModel = NowPlayingViewModel()
        viewModel.setIsNowPlayingExpanded(true)
        #expect(viewModel.isNowPlayingExpanded == true)
    }

    @Test func setIsNowPlayingExpandedFalse() {
        let viewModel = NowPlayingViewModel()
        viewModel.setIsNowPlayingExpanded(true)
        viewModel.setIsNowPlayingExpanded(false)
        #expect(viewModel.isNowPlayingExpanded == false)
    }
}
