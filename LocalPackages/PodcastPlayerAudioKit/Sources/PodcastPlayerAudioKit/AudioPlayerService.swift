import Foundation

public protocol AudioPlayerService {
    var isPlaying: Bool { get }
    func startPlaying(url: URL)
    func pause()
    func resume()
    func getPlaybackDuration() -> Double
}
