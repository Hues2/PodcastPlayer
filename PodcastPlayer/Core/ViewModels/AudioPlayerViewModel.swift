//
//  AudioPlayerViewModel.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 22/04/2026.
//

import SwiftUI
import Factory
import PodcastPlayerAudioKit

@Observable
final class AudioPlayerViewModel {
    private(set) var currentlyPlayingEpisode: EpisodeUIModel?
    private(set) var playbackState: PlaybackState = .idle
    private(set) var currentTime: Double = 0
    private(set) var duration: Double = 0

    var isPlaying: Bool { playbackState == .playing }
    var isLoading: Bool { playbackState == .loading || playbackState == .idle }
    var remainingTime: Double { max(duration - currentTime, 0) }
    private let skipSeconds: Double = 15

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
extension AudioPlayerViewModel {
    func startPlaying(episode: EpisodeUIModel) {
        // TODO: Handle invalid url
        guard let url = episode.audioURL else { return }

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

    func seekTo(seconds: Double) {
        guard currentlyPlayingEpisode != nil, !isLoading else { return }
        audioPlayerService.seekTo(seconds: seconds)
    }

    func skipBackward() {
        guard currentlyPlayingEpisode != nil, !isLoading else { return }
        self.audioPlayerService.skipBackward(seconds: skipSeconds)
    }

    func skipForward() {
        guard currentlyPlayingEpisode != nil, !isLoading else { return }
        self.audioPlayerService.skipForward(seconds: skipSeconds)
    }
}
