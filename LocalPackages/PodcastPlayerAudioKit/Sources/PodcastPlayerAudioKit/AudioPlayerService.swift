import Foundation

public protocol AudioPlayerService: Sendable {
    func play(url: URL) async
    func pause() async
    func resume() async
    func stop() async
}
