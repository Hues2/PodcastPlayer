//
//  NowPlayingExpandedView.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 23/04/2026.
//

import SwiftUI

struct NowPlayingExpandedView: View {
    let episode: EpisodeUIModel

    @Environment(AudioPlayerViewModel.self) private var audioPlayerViewModel

    var body: some View {
        Text("Now Playing Expanded View")
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

    NowPlayingExpandedView(episode: episode)
        .environment(AudioPlayerViewModel(currentlyPlayingEpisode: episode))
}
