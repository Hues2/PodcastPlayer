//
//  PodcastDetailEpisodesView.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 22/04/2026.
//

import SwiftUI

struct PodcastDetailEpisodesView: View {
    let listState: PodcastDetailViewModel.EpisodeListState

    var body: some View {
        content
    }
}

private extension PodcastDetailEpisodesView {
    @ViewBuilder
    var content: some View {
        switch listState {
        case .idle, .loading:
            ProgressView()
        case .error(let error):
            ErrorView(error: error)
        case .loaded(let episodes):
            Text("Loaded")
        }
    }
}

#Preview("Loading") {
    PodcastDetailEpisodesView(listState: .loading)
}

#Preview("Error") {
    PodcastDetailEpisodesView(listState: .error(.default))
}

#Preview("Loaded") {
    PodcastDetailEpisodesView(listState: .loaded([
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
        EpisodeUIModel(
            id: 3,
            title: "Episode 3: The End",
            description: "A thrilling conclusion.",
            duration: 3600,
            published: Date().addingTimeInterval(-172800),
            episode: 3,
            season: 1,
            type: "full",
            audioURL: nil
        ),
    ]))
}
