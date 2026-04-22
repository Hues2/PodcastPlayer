import Foundation

public protocol AudioPlayerService {
    var playbackStateStream: AsyncStream<PlaybackState> { get }
    func startPlaying(url: URL)
    func pause()
    func resume()
    func getPlaybackDuration() -> Double
}
