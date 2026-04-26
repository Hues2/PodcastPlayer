//
//  PodcastListNavigationStack.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 21/04/2026.
//

import SwiftUI

struct PodcastListNavigationStack: View {
    @Bindable var router: NavigationRouter<PodcastListScreen>
    @State private var podcastListViewModel = PodcastListViewModel()

    var body: some View {
        NavigationStack(path: $router.path) {
            PodcastListStateView(viewModel: podcastListViewModel)
                .navigationDestination(for: PodcastListScreen.self) { screen in
                    switch screen {
                    case .podcastDetail(let podcast):
                        PodcastDetailView(podcast: podcast)
                    }
                }
        }
        .environment(router)
    }
}

#Preview {
    PodcastListNavigationStack(router: .init())
}
