import Foundation

public protocol AudioPlayerService {
    func startPlaying(url: URL)
    func pause()
    func resume()
    func getPlaybackDuration() -> Double
}
