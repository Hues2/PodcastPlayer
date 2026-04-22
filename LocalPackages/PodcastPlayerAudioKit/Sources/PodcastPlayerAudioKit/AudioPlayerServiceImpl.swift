import AVFoundation
import Foundation

public final class AudioPlayerServiceImpl: AudioPlayerService {
    // MARK: - Properties
    private var player: AVPlayer?
    private var session = AVAudioSession.sharedInstance()

    // MARK: - Initialization
    public init() {}

    // MARK: - AudioPlayerService
    public func startPlaying(url: URL) {
        activateSession()

        let playerItem: AVPlayerItem = AVPlayerItem(url: url)

        if let player = player {
            player.replaceCurrentItem(with: playerItem)
        } else {
            player = AVPlayer(playerItem: playerItem)
        }

        if let player = player {
            player.play()
        }
    }

    public func pause() {
        player?.pause()
    }

    public func resume() {
        player?.play()
    }

    public func getPlaybackDuration() -> Double {
        guard let player = player else {
            return 0
        }

        return player.currentItem?.duration.seconds ?? 0
    }
}

private extension AudioPlayerServiceImpl {
    func activateSession() {
        do {
            try session.setCategory(
                .playback,
                mode: .default,
                options: []
            )
        } catch _ {}

        do {
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch _ {}

        do {
            try session.overrideOutputAudioPort(.speaker)
        } catch _ {}
    }

    func deactivateSession() {
        do {
            try session.setActive(false, options: .notifyOthersOnDeactivation)
        } catch let error as NSError {
            print("Failed to deactivate audio session: \(error.localizedDescription)")
        }
    }
}
