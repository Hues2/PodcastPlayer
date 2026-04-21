//
//  NavigationRouter.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 21/04/2026.
//

import SwiftUI

protocol Screen: Hashable {}

@Observable
class NavigationRouter<S: Screen> {
    var path: NavigationPath = NavigationPath()

    func push(_ screen: S) {
        path.append(screen)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}
