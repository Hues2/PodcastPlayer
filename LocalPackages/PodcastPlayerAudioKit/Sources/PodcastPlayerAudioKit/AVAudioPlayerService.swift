import AVFoundation
import Foundation

@MainActor
public final class AVAudioPlayerService: AudioPlayerService, @unchecked Sendable {
    // MARK: - Properties
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var statusObservation: NSKeyValueObservation?

    // MARK: - Initialization
    public init() {}

    // MARK: - AudioPlayerService
    public func play(url: URL) {
        cleanUp()

        let item = AVPlayerItem(url: url)
        playerItem = item

        let avPlayer = AVPlayer(playerItem: item)
        player = avPlayer

        statusObservation = item.observe(\.status, options: [.new]) { [weak self] item, _ in
            Task { @MainActor [weak self] in
                guard let self else { return }
                switch item.status {
                case .readyToPlay:
                    self.player?.play()
                case .failed:
                    break
                default:
                    break
                }
            }
        }
    }

    public func pause() {
        player?.pause()
    }

    public func resume() {
        player?.play()
    }

    public func stop() {
        cleanUp()
    }

    // MARK: - Private

    private func cleanUp() {
        statusObservation?.invalidate()
        statusObservation = nil
        player?.pause()
        player = nil
        playerItem = nil
    }
}
