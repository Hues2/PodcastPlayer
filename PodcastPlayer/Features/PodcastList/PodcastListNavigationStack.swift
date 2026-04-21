//
//  PodcastListNavigationStack.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 21/04/2026.
//

import SwiftUI

struct PodcastListNavigationStack: View {
    @State private var router = NavigationRouter<PodcastListScreen>()

    var body: some View {
        NavigationStack(path: $router.path) {
            PodcastListView()
                .navigationDestination(for: PodcastListScreen.self) { screen in
                    switch screen {
                    case .podcastDetail(let id):
                        Text("Podcast Detail")
                    }
                }
        }
    }
}

#Preview {
    PodcastListNavigationStack()
}
