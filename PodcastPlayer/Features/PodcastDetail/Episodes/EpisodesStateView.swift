//
//  PodcastDetailEpisodesView.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 22/04/2026.
//

import SwiftUI

struct EpisodesStateView: View {
    let listState: PodcastDetailViewModel.EpisodeListState
    let fetchEpisodes: () -> Void

    var body: some View {
        content
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

private extension EpisodesStateView {
    @ViewBuilder
    var content: some View {
        switch listState {
        case .idle, .loading:
            ProgressView()
        case .error(let error):
            if error == .noEpisodesAvailable {
                ErrorView(error: error)
            } else {
                ErrorView(error: error) { fetchEpisodes() }
            }
        case .loaded(let episodes):
            EpisodeListView(episodes: episodes)
        }
    }
}

#Preview("Loading") {
    EpisodesStateView(listState: .loading) { }
}

#Preview("Error") {
    EpisodesStateView(listState: .error(.default)) { }
}

#Preview("Loaded") {
    EpisodesStateView(listState: .loaded([
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
    ])) { }
}
