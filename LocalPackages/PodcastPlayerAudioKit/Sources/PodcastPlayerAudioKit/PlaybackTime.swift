import Foundation

public struct PlaybackTime: Sendable {
    public let currentTime: Double
    public let duration: Double

    public var remaining: Double { max(duration - currentTime, 0) }

    public init(currentTime: Double, duration: Double) {
        self.currentTime = currentTime
        self.duration = duration
    }
}
