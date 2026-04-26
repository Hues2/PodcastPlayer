//
//  NowPlayingViewModel.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 22/04/2026.
//

import SwiftUI
import Factory
import PodcastPlayerAudioKit

@Observable
final class NowPlayingViewModel {
    private(set) var currentlyPlayingEpisode: EpisodeUIModel?
    private(set) var playbackState: PlaybackState = .idle
    private(set) var currentTime: Double = .zero
    private(set) var duration: Double = .zero

    var isPlaying: Bool { playbackState == .playing }
    var isLoading: Bool { playbackState == .loading || playbackState == .idle }
    var remainingTime: Double { max(duration - currentTime, 0) }
    private let skipSeconds: Double = 15

    private(set) var isNowPlayingExpanded: Bool = false
    var error: AppError?

    @ObservationIgnored @Injected(\.audioPlayerService) private var audioPlayerService

    init(currentlyPlayingEpisode: EpisodeUIModel? = nil) {
        self.currentlyPlayingEpisode = currentlyPlayingEpisode
        observePlaybackState()
        observePlaybackTime()
    }

    private func observePlaybackTime() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            for await time in audioPlayerService.playbackTimeStream {
                self.currentTime = time.currentTime
                self.duration = time.duration
            }
        }
    }

    private func observePlaybackState() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            for await state in audioPlayerService.playbackStateStream {
                withAnimation(.snappy(duration: 0.3)) {
                    self.playbackState = state
                }
            }
        }
    }
}

// MARK: - Service Playback Methods
extension NowPlayingViewModel {
    func startPlaying(episode: EpisodeUIModel) {
        self.resetPlayback()

        guard let url = episode.audioURL else {
            self.error = .invalidEpisodeURL
            self.currentlyPlayingEpisode = nil
            return
        }

        withAnimation(.snappy(duration: 0.3)) {
            self.currentlyPlayingEpisode = episode
        }

        audioPlayerService.startPlaying(url: url)
    }

    func playPauseAction() {
        if isPlaying {
            audioPlayerService.pause()
        } else {
            audioPlayerService.resume()
        }
    }

    func seekTo(seconds: Double) async {
        guard currentlyPlayingEpisode != nil, !isLoading else { return }
        currentTime = seconds
        await audioPlayerService.seekTo(seconds: seconds)
    }

    func skipBackward() {
        guard currentlyPlayingEpisode != nil, !isLoading else { return }
        self.audioPlayerService.skipBackward(seconds: skipSeconds)
    }

    func skipForward() {
        guard currentlyPlayingEpisode != nil, !isLoading else { return }
        self.audioPlayerService.skipForward(seconds: skipSeconds)
    }

    private func resetPlayback() {
        self.playbackState = .idle
        self.currentTime = .zero
        self.duration = .zero
        self.isNowPlayingExpanded = false
    }
}

// MARK: - UI Functionality
extension NowPlayingViewModel {
    func setIsNowPlayingExpanded(_ isExpanded: Bool) {
        withAnimation(.snappy(duration: 0.3, extraBounce: 0.05)) {
            self.isNowPlayingExpanded = isExpanded
        }
    }
}
