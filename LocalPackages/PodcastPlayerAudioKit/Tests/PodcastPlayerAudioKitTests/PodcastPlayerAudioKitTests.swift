import Foundation
import Testing
@testable import PodcastPlayerAudioKit

@Test func audioPlayerServiceStopDoesNotCrash() async throws {
    let service = await AVAudioPlayerService()
    await service.stop()
}

@Test func audioPlayerServicePauseWithoutPlayDoesNotCrash() async throws {
    let service = await AVAudioPlayerService()
    await service.pause()
}

@Test func audioPlayerServiceResumeWithoutPlayDoesNotCrash() async throws {
    let service = await AVAudioPlayerService()
    await service.resume()
}
