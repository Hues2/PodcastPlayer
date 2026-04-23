//
//  ContentView.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 21/04/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var nowPlayingViewModel = NowPlayingViewModel()

    var body: some View {
        PodcastListNavigationStack()
            .overlay {
                if let episode = nowPlayingViewModel.currentlyPlayingEpisode, nowPlayingViewModel.isNowPlayingExpanded {
                    NowPlayingExpandedView(episode: episode)
                        .ignoresSafeArea()
                        .transition(.move(edge: .bottom))
                }
            }
            .environment(nowPlayingViewModel)
    }
}

#Preview {
    ContentView()
}
