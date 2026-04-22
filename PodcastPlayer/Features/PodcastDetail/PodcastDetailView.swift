//
//  PodcastDetailView.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 22/04/2026.
//

import SwiftUI
import Kingfisher

struct PodcastDetailView: View {
    let podcast: PodcastUIModel

    // Scroll State
    @State private var scrollOffset: CGFloat = 0
    @State private var scrollPosition = ScrollPosition()
    @State private var isScrolled: Bool = false

    var body: some View {
        content
    }
}

private extension PodcastDetailView {
    var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .zero) {
                image
                    .offset(y: max(0, scrollOffset))

                PodcastDetailContentView(podcast: podcast, isScrolled: isScrolled)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .scrollPosition($scrollPosition)
        .onScrollGeometryChange(for: CGFloat.self) { geometry in
            max(0, geometry.contentOffset.y)
        } action: { _, newValue in
            onScroll(newValue)
        }
        .scrollIndicators(.hidden)
        .ignoresSafeArea()
    }

    var image: some View {
        KFImage(podcast.imageURL)
            .resizable()
            .scaledToFill()
            .frame(height: 400)
            .frame(maxWidth: .infinity)
            .clipped()
            .stretchy()
    }
}

private extension PodcastDetailView {
    func onScroll(_ scrollOffset: CGFloat) {
        self.scrollOffset = scrollOffset
        withAnimation(.snappy(duration: 0.3)) {
            self.isScrolled = scrollOffset > .zero
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
