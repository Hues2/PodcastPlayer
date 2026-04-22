//
//  AudioPlayerViewModel.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 22/04/2026.
//

import Foundation
import Factory
import PodcastPlayerAudioKit

@Observable
final class AudioPlayerViewModel {
    @ObservationIgnored @Injected(\.audioPlayerService) private var audioPlayerService

}

extension AudioPlayerViewModel {
    func play(_ url: URL?) {
        guard let url else { return }
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
