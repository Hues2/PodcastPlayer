//
//  UtilsTests.swift
//  PodcastPlayerTests
//

import Testing
import Foundation
@testable import PodcastPlayer

@Suite("Utils")
struct UtilsTests {

    // MARK: - infoPlistValue

    @Test func returnsStringValueForKnownKey() {
        let identifier: String? = Utils.infoPlistValue(for: "CFBundleIdentifier")
        #expect(identifier != nil)
    }

    @Test func returnsNilForMissingKey() {
        let value: String? = Utils.infoPlistValue(for: "NonExistentKey_12345")
        #expect(value == nil)
    }

    @Test func returnsApiBaseUrl() {
        let baseURL: String? = Utils.infoPlistValue(for: "API_BASE_URL")
        #expect(baseURL == "https://the-podcasts.fly.dev/v1/")
    }

    @Test func returnsNilWhenTypeMismatches() {
        let value: Int? = Utils.infoPlistValue(for: "CFBundleIdentifier")
        #expect(value == nil)
    }
}
