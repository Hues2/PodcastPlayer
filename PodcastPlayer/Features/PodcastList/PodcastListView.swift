//
//  PodcastList.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 21/04/2026.
//

import SwiftUI

struct PodcastListView: View {
    let model: PodcastListViewModel.LoadedUIModel

    @Environment(NavigationRouter<PodcastListScreen>.self) private var router

    var body: some View {
        content
    }
}

// MARK: - View Content
private extension PodcastListView {
    var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 48) {
                if let featurePodcast = model.featured {
                    PodcastListHeaderView(podcast: featurePodcast)
                        .contentShape(.rect)
                        .onTapGesture {
                            router.push(.podcastDetail(featurePodcast))
                        }

                    Divider()
                }

                podcastList
                    .padding(.bottom, 24)
            }
        }
        .scrollIndicators(.hidden)
        .ignoresSafeArea()
    }

    var podcastList: some View {
        VStack(alignment: .leading, spacing: 48) {
            ForEach(model.podcastsByCategory.keys.sorted(), id: \.self) { categoryId in
                if let podcasts = model.podcastsByCategory[categoryId] {
                    podcastSection(categoryId, podcasts)
                }
            }
        }
    }

    func podcastSection(_ categoryId: Int, _ podcasts: [PodcastUIModel]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(.podcastList("Category \(categoryId)"))
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
                .padding(.horizontal, 24)

            ScrollView(.horizontal) {
                LazyHStack(spacing: 16) {
                    ForEach(podcasts) { podcast in
                        PodcastCardView(podcast: podcast)
                            .contentShape(.rect)
                            .onTapGesture {
                                router.push(.podcastDetail(podcast))
                            }
                    }
                }
                .padding(.horizontal, 24)
            }
            .scrollIndicators(.hidden)
            .scrollBounceBehavior(.basedOnSize)
        }
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
