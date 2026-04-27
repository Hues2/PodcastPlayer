import Testing
import Foundation
@testable import PodcastPlayerDeeplinkKit

// MARK: - Valid Deeplinks
@Suite("Deeplink Initialization")
struct DeeplinkInitTests {

    @Test func validPodcastDeeplink() {
        let url = URL(string: "podcastplayer://podcasts/12345")!
        let deeplink = Deeplink(url: url)
        #expect(deeplink == .podcast(id: 12345))
    }

    @Test func validPodcastDeeplinkWithTrailingSlash() {
        let url = URL(string: "podcastplayer://podcasts/12345/")!
        let deeplink = Deeplink(url: url)
        #expect(deeplink == .podcast(id: 12345))
    }

    @Test func validPodcastDeeplinkWithLargeId() {
        let url = URL(string: "podcastplayer://podcasts/999999999")!
        let deeplink = Deeplink(url: url)
        #expect(deeplink == .podcast(id: 999999999))
    }
}

// MARK: - Invalid Scheme
@Suite("Deeplink Invalid Scheme")
struct DeeplinkInvalidSchemeTests {

    @Test func wrongSchemeReturnsNil() {
        let url = URL(string: "https://podcasts/12345")!
        #expect(Deeplink(url: url) == nil)
    }

    @Test func emptySchemeReturnsNil() {
        let url = URL(string: "://podcasts/12345")!
        #expect(Deeplink(url: url) == nil)
    }
}

// MARK: - Invalid Host
@Suite("Deeplink Invalid Host")
struct DeeplinkInvalidHostTests {

    @Test func unknownHostReturnsNil() {
        let url = URL(string: "podcastplayer://unknown/12345")!
        #expect(Deeplink(url: url) == nil)
    }

    @Test func missingHostReturnsNil() {
        let url = URL(string: "podcastplayer:///12345")!
        #expect(Deeplink(url: url) == nil)
    }
}

// MARK: - Invalid Path / ID
@Suite("Deeplink Invalid Path")
struct DeeplinkInvalidPathTests {

    @Test func missingIdReturnsNil() {
        let url = URL(string: "podcastplayer://podcasts")!
        #expect(Deeplink(url: url) == nil)
    }

    @Test func missingIdWithTrailingSlashReturnsNil() {
        let url = URL(string: "podcastplayer://podcasts/")!
        #expect(Deeplink(url: url) == nil)
    }

    @Test func nonNumericIdReturnsNil() {
        let url = URL(string: "podcastplayer://podcasts/abc")!
        #expect(Deeplink(url: url) == nil)
    }

    @Test func negativeIdReturnsNil() {
        let url = URL(string: "podcastplayer://podcasts/-1")!
        #expect(Deeplink(url: url) == nil)
    }
}

// MARK: - URL Generation
@Suite("Deeplink URL Generation")
struct DeeplinkURLGenerationTests {

    @Test func podcastDetailDeeplinkReturnsCorrectURL() {
        let url = Deeplink.getPodcastDetailDeeplink(for: 12345)
        #expect(url?.absoluteString == "podcastplayer://podcasts/12345")
    }

    @Test func podcastDetailDeeplinkRoundTrips() {
        let url = Deeplink.getPodcastDetailDeeplink(for: 42)!
        let deeplink = Deeplink(url: url)
        #expect(deeplink == .podcast(id: 42))
    }
}

// MARK: - Static Properties
@Suite("Deeplink Static Properties")
struct DeeplinkStaticPropertyTests {

    @Test func uriSchemeIsCorrect() {
        #expect(Deeplink.uriScheme == "podcastplayer")
    }

    @Test func podcastURLHostIsCorrect() {
        #expect(Deeplink.podcastURLHost == "podcasts")
    }
}
