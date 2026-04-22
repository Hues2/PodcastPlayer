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

    @ObservationIgnored @Injected(\.audioPlayerService) private var audioPlayerService

    init(currentlyPlayingEpisode: EpisodeUIModel? = nil) {
        self.currentlyPlayingEpisode = currentlyPlayingEpisode
    }
}

// MARK: - Service Playback Methods
extension AudioPlayerViewModel {
    func startPlaying(episode: EpisodeUIModel) {
        guard let url = episode.audioURL else { return }

        withAnimation(.snappy(duration: 0.3)) {
            self.currentlyPlayingEpisode = episode
        }

        audioPlayerService.startPlaying(url: url)
    }

    func resume() {
        audioPlayerService.resume()
    }

    func pause() {
        audioPlayerService.pause()
    }
}
