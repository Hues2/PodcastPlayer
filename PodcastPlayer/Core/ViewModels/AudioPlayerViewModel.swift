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

    var isPlaying: Bool { playbackState == .playing }
    var isLoading: Bool { playbackState == .loading || playbackState == .idle }
    private let skipSeconds: Double = 15

    @ObservationIgnored @Injected(\.audioPlayerService) private var audioPlayerService

    init(currentlyPlayingEpisode: EpisodeUIModel? = nil) {
        self.currentlyPlayingEpisode = currentlyPlayingEpisode
        observePlaybackState()
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

    func skipBackward() {
        guard currentlyPlayingEpisode != nil, !isLoading else { return }
        self.audioPlayerService.skipBackward(seconds: skipSeconds)
    }

    func skipForward() {
        guard currentlyPlayingEpisode != nil, !isLoading else { return }
        self.audioPlayerService.skipForward(seconds: skipSeconds)
    }
}
