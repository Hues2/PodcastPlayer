//
//  NavigationRouterTests.swift
//  PodcastPlayerTests
//

import Testing
import SwiftUI
@testable import PodcastPlayer

private enum TestScreen: Screen {
    case first
    case second
    case third
}

@Suite("NavigationRouter")
struct NavigationRouterTests {
    private let router = NavigationRouter<TestScreen>()

    // MARK: - Initial State

    @Test func initialPathIsEmpty() {
        #expect(router.path.isEmpty)
    }

    // MARK: - Push

    @Test func pushAddsScreenToPath() {
        router.push(.first)
        #expect(router.path.count == 1)
    }

    @Test func pushMultipleScreens() {
        router.push(.first)
        router.push(.second)
        router.push(.third)
        #expect(router.path.count == 3)
    }

    // MARK: - Pop

    @Test func popRemovesLastScreen() {
        router.push(.first)
        router.push(.second)
        router.pop()
        #expect(router.path.count == 1)
    }

    @Test func popOnEmptyPathDoesNothing() {
        router.pop()
        #expect(router.path.isEmpty)
    }

    @Test func popAllScreensOneByOne() {
        router.push(.first)
        router.push(.second)
        router.pop()
        router.pop()
        #expect(router.path.isEmpty)
    }

    // MARK: - Pop to Root

    @Test func popToRootClearsEntirePath() {
        router.push(.first)
        router.push(.second)
        router.push(.third)
        router.popToRoot()
        #expect(router.path.isEmpty)
    }

    @Test func popToRootOnSingleScreen() {
        router.push(.first)
        router.popToRoot()
        #expect(router.path.isEmpty)
    }

    @Test func popToRootOnEmptyPath() {
        router.popToRoot()
        #expect(router.path.isEmpty)
    }
}
