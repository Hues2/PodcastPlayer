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
            .sheet(
                isPresented: Binding(
                    get: { nowPlayingViewModel.isNowPlayingExpanded &&
                        nowPlayingViewModel.currentlyPlayingEpisode != nil },
                    set: { nowPlayingViewModel.setIsNowPlayingExpanded($0) }
                )
            ) {
                if let episode = nowPlayingViewModel.currentlyPlayingEpisode, nowPlayingViewModel.isNowPlayingExpanded {
                    NowPlayingExpandedView(episode: episode)
                        .dynamicTypeSize(.xSmall ... .accessibility1)
                }
            }
            .environment(nowPlayingViewModel)
            .alert(
                nowPlayingViewModel.error?.errorTitle ?? "",
                isPresented: Binding(
                    get: { nowPlayingViewModel.error != nil },
                    set: { if !$0 { nowPlayingViewModel.error = nil } }
                )
            ) {
                Button("Ok", role: .cancel) { }
            } message: {
                Text(nowPlayingViewModel.error?.errorDescription ?? "")
            }
    }
}

#Preview {
    ContentView()
}
