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
    func play(episode: EpisodeUIModel) {
        guard let url = episode.audioURL else { return }

        withAnimation(.snappy(duration: 0.3)) {
            self.currentlyPlayingEpisode = episode
        }

        Task {
            await audioPlayerService.play(url: url)
        }
    }

    func resume() {
        Task {
            await audioPlayerService.resume()
        }
    }

    func pause() {
        Task {
            await audioPlayerService.pause()
        }
    }

    func stop() {
        Task {
            await audioPlayerService.stop()
        }
    }
}
