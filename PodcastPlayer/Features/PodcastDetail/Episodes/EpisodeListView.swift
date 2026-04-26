//
//  EpisodeListView.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 22/04/2026.
//

import SwiftUI

struct EpisodeListView: View {
    let episodes: [EpisodeUIModel]

    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            header

            if episodes.isEmpty {
                emptyListView
            } else {
                listView
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var header: some View {
        HStack(alignment: .center, spacing: 8) {
            Image(systemName: "list.bullet")
            Text(.podcastDetail("Episodes"))
        }
        .font(.title)
        .fontWeight(.semibold)
        .foregroundStyle(.primary)
    }

    var emptyListView: some View {
        Text(.podcastDetail("No episodes available"))
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }

    var listView: some View {
        LazyVStack(alignment: .leading, spacing: 24) {
            ForEach(episodes) { episode in
                EpisodeView(episode: episode)

                if episodes.last != episode {
                    Divider()
                }
            }
        }
    }
}

#Preview {
    EpisodeListView(episodes: [
        EpisodeUIModel(
            id: 1,
            title: "Episode 1: The Beginning",
            description: "An introduction to the series.",
            duration: 1800,
            published: Date(),
            episode: 1,
            season: 1,
            type: "full",
            audioURL: nil
        ),
        EpisodeUIModel(
            id: 2,
            title: "Episode 2: The Middle",
            description: "Things start to get interesting.",
            duration: 2400,
            published: Date().addingTimeInterval(-86400),
            episode: 2,
            season: 1,
            type: "full",
            audioURL: nil
        ),
    ])
}

#Preview("Empty") {
    EpisodeListView(episodes: [])
}
