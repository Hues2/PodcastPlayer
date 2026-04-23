//
//  NowPlayingView.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 23/04/2026.
//

import SwiftUI

struct NowPlayingView: View {
    let episode: EpisodeUIModel

    @State private var isExpanded: Bool = false

    var body: some View {
        content
    }
}

private extension NowPlayingView {
    @ViewBuilder
    var content: some View {
        if isExpanded {
            NowPlayingExpandedView(episode: episode)
        } else {
            NowPlayingCompactView(episode: episode)
        }
    }
}

#Preview {
    let episode = EpisodeUIModel(
        id: 1,
        title: "The Fall of the Roman Empire",
        description: "A deep dive into the fall of Rome.",
        duration: 3600,
        published: Date(),
        episode: 1,
        season: 1,
        type: "full",
        audioURL: nil,
        podcastTitle: "The Rest Is History",
        podcastImageURL: URL(string: "https://the-podcasts.fly.dev/v1/images/c22c9113-a022-5940-bc79-bd4fea8b1c04")
    )

    NowPlayingView(episode: episode)
        .environment(AudioPlayerViewModel(currentlyPlayingEpisode: episode))
}
