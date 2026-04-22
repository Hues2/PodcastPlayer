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
    private(set) var isPlaying: Bool = false

    @ObservationIgnored @Injected(\.audioPlayerService) private var audioPlayerService

    init(currentlyPlayingEpisode: EpisodeUIModel? = nil) {
        self.currentlyPlayingEpisode = currentlyPlayingEpisode
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

        setIsPlaying(true)
    }

    func playPauseAction() {
        if self.isPlaying {
            self.pause()
        } else {
            self.resume()
        }
    }

    private func resume() {
        audioPlayerService.resume()
        setIsPlaying(true)
    }

    private func pause() {
        audioPlayerService.pause()
        setIsPlaying(false)
    }
}

extension AudioPlayerViewModel {
    func setIsPlaying(_ isPlaying: Bool) {
        withAnimation(.snappy(duration: 0.3)) {
            self.isPlaying = isPlaying
        }
    }
}
