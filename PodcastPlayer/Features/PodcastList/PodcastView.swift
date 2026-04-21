//
//  PodcastView.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 21/04/2026.
//

import SwiftUI
import Kingfisher

struct PodcastView: View {
    let podcast: PodcastUIModel

    var body: some View {
        content
    }
}

// MARK: - View Content
private extension PodcastView {
    var content: some View {
        VStack(alignment: .leading, spacing: 8) {
            imageView
            infoView
        }
        .frame(width: 150)
    }

    var imageView: some View {
        KFImage(podcast.imageURL)
            .resizable()
            .scaledToFill()
            .frame(width: 150, height: 150)
            .clipShape(.rect(cornerRadius: 20))            
    }

    var infoView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(podcast.title)
                .font(.headline)
                .fontWeight(.semibold)
                .lineLimit(2)

            if let author = podcast.author {
                Text(author)
                    .font(.subheadline)
                    .fontWeight(.light)
                    .lineLimit(1)
            }
        }
        .foregroundStyle(.primary)
    }
}

#Preview {
    let preview = PodcastUIModel(
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
    )
    PodcastView(podcast: preview)
        .padding()
}
