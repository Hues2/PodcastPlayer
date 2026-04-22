//
//  PodcastList.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 21/04/2026.
//

import SwiftUI

struct PodcastListLoadedView: View {
    let model: PodcastListViewModel.LoadedUIModel

    @Environment(NavigationRouter<PodcastListScreen>.self) private var router

    var body: some View {
        content
    }
}

// MARK: - View Content
private extension PodcastListLoadedView {
    var content: some View {
        ScrollView {
            if let featurePodcast = model.featured {
                PodcastListHeaderView(podcast: featurePodcast)
            }
            podcastList
        }
        .scrollIndicators(.hidden)
        .ignoresSafeArea()
    }

    var podcastList: some View {
        VStack(alignment: .leading, spacing: 24) {
            ForEach(model.podcasts) { podcast in
                PodcastView(podcast: podcast)
                    .contentShape(.rect)
                    .onTapGesture {
                        router.push(.podcastDetail(podcast.id))
                    }
            }
            .padding(24)
        }
    }
}

#Preview {
    NavigationStack {
        PodcastListLoadedView(model: .init(
            featured: PodcastUIModel(
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
            podcasts: [
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
                PodcastUIModel(
                    id: 484971,
                    title: "The Rest Is History",
                    author: "Goalhanger",
                    categoryIds: [1487],
                    description: "Take a deep dive into History's biggest moments with Tom Holland & Dominic Sandbrook.",
                    imageURL: URL(string: "https://the-podcasts.fly.dev/v1/images/c22c9113-a022-5940-bc79-bd4fea8b1c04"),
                    languageIso: "en",
                    link: "http://therestishistory.com",
                    popularity: 8136.05,
                    rss: "https://feeds.megaphone.fm/GLT4787413333",
                    seasonal: false,
                    type: "episodic"
                ),
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
                PodcastUIModel(
                    id: 58952,
                    title: "Casefile True Crime",
                    author: "Casefile Presents",
                    categoryIds: [1488],
                    description: "Fact is scarier than fiction.",
                    imageURL: URL(string: "https://the-podcasts.fly.dev/v1/images/0ea387bd-f04a-5413-a45c-59f3e56d6896"),
                    languageIso: "en",
                    link: "https://casefilepodcast.com",
                    popularity: 8071.26,
                    rss: "https://feeds.acast.com/public/shows/679acff465f74095106abfaa",
                    seasonal: false,
                    type: "episodic"
                ),
                PodcastUIModel(
                    id: 12300,
                    title: "48 Hours",
                    author: "CBS News",
                    categoryIds: [1488],
                    description: "48 Hours uncovers the narrative behind crime and justice cases.",
                    imageURL: URL(string: "https://the-podcasts.fly.dev/v1/images/d14f77ea-dbd3-5f8b-bf6c-54e487d48c31"),
                    languageIso: "en",
                    link: "https://www.cbsnews.com/48-hours/",
                    popularity: 7923.15,
                    rss: "https://feeds.megaphone.fm/CBS8186808081",
                    seasonal: false,
                    type: "episodic"
                ),
                PodcastUIModel(
                    id: 19296,
                    title: "Morbid",
                    author: "Ash Kelley & Alaina Urquhart",
                    categoryIds: [1488],
                    description: "It's a lighthearted nightmare in here, weirdos!",
                    imageURL: URL(string: "https://the-podcasts.fly.dev/v1/images/88b4617c-fb7f-5ae2-86f8-cbac21e3f54c"),
                    languageIso: "en",
                    link: "https://morbid-53aa329e.simplecast.com",
                    popularity: 7856.71,
                    rss: "https://feeds.simplecast.com/ohmVlJZQ",
                    seasonal: false,
                    type: "episodic"
                ),
                PodcastUIModel(
                    id: 891314,
                    title: "The Rest Is Politics",
                    author: "Goalhanger",
                    categoryIds: [1489, 1527],
                    description: "Alastair Campbell and Rory Stewart break down current affairs.",
                    imageURL: URL(string: "https://the-podcasts.fly.dev/v1/images/d17fd993-4a64-5e0c-803c-128fc250972e"),
                    languageIso: "en",
                    link: "http://therestispolitics.com/",
                    popularity: 7806.54,
                    rss: "https://feeds.megaphone.fm/GLT9190936013",
                    seasonal: false,
                    type: "episodic"
                ),
                PodcastUIModel(
                    id: 65075,
                    title: "RedHanded",
                    author: "RedHanded",
                    categoryIds: [1488],
                    description: "RedHanded the podcast jumps head first into all manner of macabre madness.",
                    imageURL: URL(string: "https://the-podcasts.fly.dev/v1/images/eeefc1f0-8f3c-501d-a035-1c0d1fd43654"),
                    languageIso: "en",
                    link: "https://audioboom.com/channels/5166531",
                    popularity: 7559.39,
                    rss: "https://audioboom.com/channels/5166531.rss",
                    seasonal: false,
                    type: "episodic"
                ),
                PodcastUIModel(
                    id: 1202166,
                    title: "The Rest Is Politics: US",
                    author: "Goalhanger",
                    categoryIds: [1489, 1527],
                    description: "TRIP US uncovers secrets from inside the White House inner circles.",
                    imageURL: URL(string: "https://the-podcasts.fly.dev/v1/images/8abc5fc6-8954-54b9-b58b-f2146e4112f9"),
                    languageIso: "en",
                    link: "http://therestispoliticsus.com/",
                    popularity: 7513.73,
                    rss: "https://feeds.megaphone.fm/GLT5336643697",
                    seasonal: false,
                    type: "episodic"
                ),
            ]
        ))
    }
    .environment(NavigationRouter<PodcastListScreen>())
}
