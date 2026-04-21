//
//  PodcastView.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 21/04/2026.
//

import SwiftUI

struct PodcastView: View {
    let podcast: PodcastUIModel

    var body: some View {
        HStack(spacing: 12) {
            // Podcast artwork placeholder
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 80, height: 80)
                .overlay {
                    Image(systemName: "headphones")
                        .font(.title)
                        .foregroundStyle(.secondary)
                }

            VStack(alignment: .leading, spacing: 4) {
                Text(podcast.title)
                    .font(.headline)
                    .lineLimit(1)

                if let author = podcast.author {
                    Text(author)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                if let description = podcast.description {
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .lineLimit(2)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    let preview = PodcastUIModel(
        id: 484971,
        title: "The Rest Is History",
        author: "Goalhanger",
        categoryIds: [1487],
        description: "Take a deep dive into History's biggest moments with Tom Holland & Dominic Sandbrook.\n\nExplore the stories of History's most brutal rulers, deadly battles, and world-changing events.",
        imageId: "c22c9113-a022-5940-bc79-bd4fea8b1c04",
        languageIso: "en",
        link: "http://therestishistory.com",
        popularity: 8136.05,
        rss: "https://feeds.megaphone.fm/GLT4787413333",
        seasonal: false,
        type: "episodic"
    )
    PodcastView(podcast: preview)
        .padding()
}
