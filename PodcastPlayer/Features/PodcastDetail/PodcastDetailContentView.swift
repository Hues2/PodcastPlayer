//
//  PodcastDetailContentView.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 22/04/2026.
//

import SwiftUI

struct PodcastDetailContentView: View {
    let podcast: PodcastUIModel
    let isScrolled: Bool
    let episodeListState: PodcastDetailViewModel.EpisodeListState

    var body: some View {
        content
            .frame(maxWidth: .infinity)
            .background(.background)
            .clipShape(.rect(cornerRadii: .init(
                topLeading: 16,
                topTrailing: 16
            )))
            .shadow(color: isScrolled ? .black.opacity(0.2) : .clear, radius: 2, x: 0, y: -4)
    }
}

private extension PodcastDetailContentView {
    var content: some View {
        VStack(alignment: .leading, spacing: 16) {
            SheetDragIndicator()
                .opacity(isScrolled ? 1 : 0)

            VStack(alignment: .leading, spacing: 40) {
                infoView
                    .padding(.horizontal, 24)

                Divider()

                EpisodesStateView(listState: episodeListState)
                    .padding(.horizontal, 24)
            }
        }
        .padding(.bottom, 24)
    }

    var infoView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(podcast.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.primary)

            if let author = podcast.author {
                Text(author)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if let description = podcast.description {
                Text(description)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .padding(.top, 12)
            }
        }
    }
}

#Preview {
    PodcastDetailView(podcast: PodcastUIModel(
        id: 484971,
        title: "The Rest Is History",
        author: "Goalhanger",
        categoryIds: [1487],
        description: "Take a deep dive into History's biggest moments with Tom Holland & Dominic Sandbrook.\n\nExplore the stories of History's most brutal rulers, deadly battles, and world-changing events.",
        imageURL: URL(string: "https://the-podcasts.fly.dev/v1/images/c22c9113-a022-5940-bc79-bd4fea8b1c04"),
        languageIso: "en",
        link: "http://therestishistory.com",
        popularity: 8136.05,
        rss: "https://feeds.megaphone.fm/GLT4787413333",
        seasonal: false,
        type: "episodic"
    ))
}
