//
//  NavigationRouter.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 21/04/2026.
//

import SwiftUI

protocol Screen: Hashable {}

@Observable
final class NavigationRouter<S: Screen> {
    var path: NavigationPath = NavigationPath()
    private(set) var screens: [S] = []

    var lastScreen: S? { screens.last }

    func push(_ screen: S) {
        path.append(screen)
        screens.append(screen)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
        screens.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
        screens.removeAll()
    }
}
