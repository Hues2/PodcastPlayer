//
//  ContentView.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 21/04/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var router = NavigationRouter<PodcastListScreen>()
    @State private var nowPlayingViewModel = NowPlayingViewModel()

    var body: some View {
        PodcastListNavigationStack(router: router)
            .sheet(
                isPresented: Binding(
                    get: { nowPlayingViewModel.isNowPlayingExpanded &&
                        nowPlayingViewModel.currentlyPlayingEpisode != nil },
                    set: { nowPlayingViewModel.setIsNowPlayingExpanded($0) }
                )
            ) {
                if let episode = nowPlayingViewModel.currentlyPlayingEpisode, nowPlayingViewModel.isNowPlayingExpanded {
                    NowPlayingExpandedView(episode: episode)
                        .presentationDetents([.large])
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
                Button(.error("Ok"), role: .cancel) { }
            } message: {
                Text(nowPlayingViewModel.error?.errorDescription ?? "")
            }
            .onOpenURL { url in
                guard let deeplink = Deeplink(url: url) else { return }
                switch deeplink {
                case .podcast(let id):
                    router.push(.podcastDetailById(id))
                }
            }
    }
}

#Preview {
    ContentView()
}
