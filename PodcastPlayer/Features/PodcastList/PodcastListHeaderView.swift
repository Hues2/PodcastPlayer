//
//  PodcastListHeaderView.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 22/04/2026.
//

import SwiftUI
import Kingfisher

struct PodcastListHeaderView: View {
    let podcast: PodcastUIModel
    
    var body: some View {
        content
    }
}

// MARK: - View Content
private extension PodcastListHeaderView {
    var content: some View {
        VStack(spacing: 20) {
            image
            infoView
        }
    }
    
    var image: some View {
        KFImage(podcast.imageURL)
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .frame(maxHeight: 400)
            .clipped()
            .stretchy()
    }
    
    var infoView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(.podcastList("Featured"))
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(Color.accentColor)
            
            Text(podcast.title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            if let description = podcast.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
    }
}

#Preview {
    NavigationStack {
        PodcastListView(model: .init(
            featured: PodcastUIModel(
                id: 35027,
                title: "The Daily",
                author: "The New York Times",
                categoryIds: [1489, 1526],
                description: "This is what the news should sound like.",
                imageURL: URL(string: "https://the-podcasts.fly.dev/v1/images/fecafc63-6f75-51cd-abe2-e001cdfe4e40"),
                languageIso: "en",
                link: "https://www.nytimes.com/the-daily",
                popularity: 8116.49,
                rss: "https://feeds.simplecast.com/54nAGcIl",
                seasonal: false,
                type: "episodic"
            ),
            podcastsByCategory: [
                1488: [
                    PodcastUIModel(
                        id: 41593,
                        title: "Crime Junkie",
                        author: "Audiochuck",
                        categoryIds: [1488],
                        description: "Does hearing about a true crime case always leave you scouring the internet for the truth behind the story?",
                        imageURL: URL(string: "https://the-podcasts.fly.dev/v1/images/36eecc73-1b1e-593d-91ad-073f7680babf"),
                        languageIso: "en",
                        link: "https://audiochuck.com",
                        popularity: 8172.28,
                        rss: "https://feeds.simplecast.com/qm_9xx0g",
                        seasonal: false,
                        type: "episodic"
                    ),
                    PodcastUIModel(
                        id: 129587,
                        title: "Dateline NBC",
                        author: "NBC News",
                        categoryIds: [1488],
                        description: "Current and classic episodes, featuring compelling true-crime mysteries.",
                        imageURL: URL(string: "https://the-podcasts.fly.dev/v1/images/68331813-a93b-50a2-9313-72c3b7ed5519"),
                        languageIso: "en",
                        link: "https://www.nbcnews.com/dateline",
                        popularity: 8166.98,
                        rss: "https://podcastfeeds.nbcnews.com/dateline",
                        seasonal: false,
                        type: "episodic"
                    ),
                ],
                1489: [
                    PodcastUIModel(
                        id: 35027,
                        title: "The Daily",
                        author: "The New York Times",
                        categoryIds: [1489, 1526],
                        description: "This is what the news should sound like.",
                        imageURL: URL(string: "https://the-podcasts.fly.dev/v1/images/fecafc63-6f75-51cd-abe2-e001cdfe4e40"),
                        languageIso: "en",
                        link: "https://www.nytimes.com/the-daily",
                        popularity: 8116.49,
                        rss: "https://feeds.simplecast.com/54nAGcIl",
                        seasonal: false,
                        type: "episodic"
                    ),
                ],
            ]
        ))
    }
    .environment(NavigationRouter<PodcastListScreen>())
}
