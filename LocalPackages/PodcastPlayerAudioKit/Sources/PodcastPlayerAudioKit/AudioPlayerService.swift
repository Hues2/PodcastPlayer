import Foundation

public protocol AudioPlayerService {
    var playbackStateStream: AsyncStream<PlaybackState> { get }
    var playbackTimeStream: AsyncStream<PlaybackTime> { get }
    func startPlaying(url: URL)
    func pause()
    func resume()
    func seekTo(seconds: Double) async
    func skipForward(seconds: Double)
    func skipBackward(seconds: Double)
}
