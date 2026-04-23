import AVFoundation
import Foundation
import os

public final class AudioPlayerServiceImpl: AudioPlayerService {
    // MARK: - Properties
    private var player: AVPlayer?
    private var session = AVAudioSession.sharedInstance()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "AudioPlayerService", category: "AudioPlayerService")
    private var timeControlStatusObservation: NSKeyValueObservation?
    private var timeObserver: Any?
    private var playbackStateContinuation: AsyncStream<PlaybackState>.Continuation?
    private var playbackTimeContinuation: AsyncStream<PlaybackTime>.Continuation?

    public let playbackStateStream: AsyncStream<PlaybackState>
    public let playbackTimeStream: AsyncStream<PlaybackTime>

    // MARK: - Initialization
    public init() {
        var stateContinuation: AsyncStream<PlaybackState>.Continuation!
        playbackStateStream = AsyncStream { stateContinuation = $0 }
        playbackStateContinuation = stateContinuation

        var timeContinuation: AsyncStream<PlaybackTime>.Continuation!
        playbackTimeStream = AsyncStream { timeContinuation = $0 }
        playbackTimeContinuation = timeContinuation
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
            addPeriodicTimeObserver(to: player)
            player.play()
        }
    }

    public func pause() {
        player?.pause()
    }

    public func resume() {
        player?.play()
    }

    public func seekTo(seconds: Double) async {
        guard let player else { return }
        let time = CMTimeMakeWithSeconds(seconds, preferredTimescale: 600)
        await player.seek(to: time)
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

    func addPeriodicTimeObserver(to player: AVPlayer) {
        if let timeObserver {
            player.removeTimeObserver(timeObserver)
        }
        let interval = CMTimeMakeWithSeconds(0.5, preferredTimescale: 600)
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            let currentTime = time.seconds
            let duration = player.currentItem?.duration.seconds ?? 0
            guard currentTime.isFinite, duration.isFinite else { return }
            self?.playbackTimeContinuation?.yield(PlaybackTime(currentTime: currentTime, duration: duration))
        }
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
        } catch {
            logger.debug("Failed to set audio session category: \(error.localizedDescription, privacy: .public)")
        }

        do {
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            logger.debug("Failed to activate audio session: \(error.localizedDescription, privacy: .public)")
        }

        do {
            try session.overrideOutputAudioPort(.speaker)
        } catch {
            logger.debug("Failed to override output audio port: \(error.localizedDescription, privacy: .public)")
        }
    }

    func deactivateSession() {
        do {
            try session.setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            logger.debug("Failed to deactivate audio session: \(error.localizedDescription, privacy: .public)")
        }
    }
}
