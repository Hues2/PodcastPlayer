//
//  PlayingPodcastView.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 22/04/2026.
//

import SwiftUI
import Kingfisher

struct PlayingPodcastView: View {
    let episode: EpisodeUIModel

    private enum Layout {
        static let imageCornerRadius: CGFloat = 8
        static let imageSize: CGFloat = 64
        static let padding: CGFloat = 12
    }

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            HStack(spacing: 12) {
                KFImage(episode.podcastImageURL)
                    .resizable()
                    .scaledToFill()
                    .frame(width: Layout.imageSize, height: Layout.imageSize)
                    .clipShape(RoundedRectangle(cornerRadius: Layout.imageCornerRadius))

                VStack(alignment: .leading, spacing: 2) {
                    Text(episode.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .lineLimit(1)

                    if let podcastTitle = episode.podcastTitle {
                        Text(podcastTitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(Layout.padding)
        .background(.ultraThickMaterial)
        .ignoresSafeArea()
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

    PlayingPodcastView(episode: episode)        
}
