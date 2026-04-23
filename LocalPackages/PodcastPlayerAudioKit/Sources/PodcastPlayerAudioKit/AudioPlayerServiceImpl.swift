import AVFoundation
import Foundation

public final class AudioPlayerServiceImpl: AudioPlayerService {
    // MARK: - Properties
    private var player: AVPlayer?
    private var session = AVAudioSession.sharedInstance()
    private var timeControlStatusObservation: NSKeyValueObservation?
    private var playbackStateContinuation: AsyncStream<PlaybackState>.Continuation?

    public let playbackStateStream: AsyncStream<PlaybackState>

    // MARK: - Initialization
    public init() {
        var continuation: AsyncStream<PlaybackState>.Continuation!
        playbackStateStream = AsyncStream { continuation = $0 }
        playbackStateContinuation = continuation
    }

    // MARK: - AudioPlayerService
    public func startPlaying(url: URL) {
        activateSession()

        let playerItem: AVPlayerItem = AVPlayerItem(url: url)

        if let player {
            player.replaceCurrentItem(with: playerItem)
        } else {
            player = AVPlayer(playerItem: playerItem)
        }

        if let player {
            observeTimeControlStatus(of: player)
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
        player?.currentItem?.duration.seconds ?? 0
    }

    public func skipForward(seconds: Double) {
        skip(by: seconds)
    }

    public func skipBackward(seconds: Double) {
        skip(by: -seconds)
    }
}

private extension AudioPlayerServiceImpl {
    func skip(by seconds: Double) {
        guard let player, let currentItem = player.currentItem else { return }
        let currentTime = player.currentTime()
        let duration = currentItem.duration
        let newTime = CMTimeAdd(currentTime, CMTimeMakeWithSeconds(seconds, preferredTimescale: currentTime.timescale))
        let clampedTime = CMTimeClampToRange(newTime, range: CMTimeRange(start: .zero, end: duration))
        player.seek(to: clampedTime)
    }

    func observeTimeControlStatus(of player: AVPlayer) {
        timeControlStatusObservation = player.observe(\.timeControlStatus) { [weak self] player, _ in
            let state: PlaybackState = switch player.timeControlStatus {
            case .paused: .paused
            case .waitingToPlayAtSpecifiedRate: .loading
            case .playing: .playing
            @unknown default: .idle
            }
            self?.playbackStateContinuation?.yield(state)
        }
    }

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
