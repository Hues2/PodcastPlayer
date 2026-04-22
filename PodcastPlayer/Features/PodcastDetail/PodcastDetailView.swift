//
//  PodcastDetailView.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 22/04/2026.
//

import SwiftUI
import Kingfisher

struct PodcastDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: PodcastDetailViewModel

    init(podcast: PodcastUIModel) {
        self._viewModel = State(initialValue: PodcastDetailViewModel(podcast: podcast))
    }

    // Scroll State
    @State private var scrollOffset: CGFloat = 0
    @State private var scrollPosition = ScrollPosition()
    @State private var isScrolled: Bool = false
    @State private var showNavigationBackground: Bool = false

    private let imageHeight: CGFloat = 400

    var body: some View {
        content
            .overlay(alignment: .top) {
                navigationBar
            }
            .toolbarVisibility(.hidden, for: .navigationBar)
            .task { await viewModel.fetchEpisodes() }
    }
}

private extension PodcastDetailView {
    var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .zero) {
                image
                    .offset(y: max(0, scrollOffset))

                PodcastDetailContentView(
                    podcast: viewModel.podcast,
                    isScrolled: isScrolled,
                    episodeListState: viewModel.episodeListState
                )
            }
        }
        .scrollPosition($scrollPosition)
        .onScrollGeometryChange(for: CGFloat.self) { geometry in
            max(0, geometry.contentOffset.y)
        } action: { _, newValue in
            onScroll(newValue)
        }
        .scrollIndicators(.hidden)
        .ignoresSafeArea()
    }

    var navigationBar: some View {
        HStack(alignment: .center, spacing: 8) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(.primary)
                    .fontWeight(.semibold)
                    .padding()
                    .background(.thickMaterial)
                    .clipShape(.circle)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .buttonStyle(.plain)
        }
        .padding()
        .background {
            if showNavigationBackground {
                Color(.systemBackground)
                    .ignoresSafeArea()
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .ignoresSafeArea()
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
            }
        }
    }

    var image: some View {
        KFImage(viewModel.podcast.imageURL)
            .resizable()
            .scaledToFill()
            .frame(height: imageHeight)
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
            self.showNavigationBackground = scrollOffset > imageHeight - 76
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
