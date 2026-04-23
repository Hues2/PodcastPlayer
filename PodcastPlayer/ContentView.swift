//
//  ContentView.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 21/04/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var audioPlayerViewModel = AudioPlayerViewModel()
    @State private var isNowPlayingExpanded: Bool = false

    var body: some View {
        PodcastListNavigationStack()
            .safeAreaInset(edge: .bottom) {
                if let episode = audioPlayerViewModel.currentlyPlayingEpisode, !isNowPlayingExpanded {
                    NowPlayingCompactView(episode: episode, setIsExpanded: setIsNowPlayingExpanded)
                        .transition(.move(edge: .bottom))
                }
            }
            .overlay {
                if let episode = audioPlayerViewModel.currentlyPlayingEpisode, isNowPlayingExpanded {
                    NowPlayingExpandedView(episode: episode, setIsExpanded: setIsNowPlayingExpanded)
                        .ignoresSafeArea()
                        .transition(.move(edge: .bottom))
                }
            }
            .environment(audioPlayerViewModel)
    }
}

private extension ContentView {
    func setIsNowPlayingExpanded(_ isExpanded: Bool) {
        withAnimation(.snappy(duration: 0.3, extraBounce: 0.05)) {
            self.isNowPlayingExpanded = isExpanded
        }
    }
}

#Preview {
    ContentView()
}
