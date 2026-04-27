//
//  PodcastDetailView.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 22/04/2026.
//

import SwiftUI
import Kingfisher

struct PodcastDetailView: View {
    @State private var viewModel: PodcastDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(NowPlayingViewModel.self) private var nowPlayingViewModel

    init(podcast: PodcastUIModel) {
        self._viewModel = State(initialValue: PodcastDetailViewModel(podcast: podcast))
    }

    init(id: Int) {
        self._viewModel = State(initialValue: PodcastDetailViewModel(id: id))
    }

    // Scroll State
    @State private var scrollOffset: CGFloat = 0
    @State private var scrollPosition = ScrollPosition()
    @State private var isScrolled: Bool = false
    @State private var showNavigationBackground: Bool = false

    private let imageHeight: CGFloat = 400

    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .top) { navigationBar(podcast: viewModel.podcast) }
            .toolbarVisibility(.hidden, for: .navigationBar)
            .task { await viewModel.fetchData() }
    }
}

// MARK: - View Content
private extension PodcastDetailView {
    var content: some View {
        Group {
            switch viewModel.podcastState {
            case .idle, .loading:
                ProgressView()
            case .error(let error):
                ErrorView(error: error, buttonTitle: .error("Ok")) { dismiss() }
            case .loaded(let podcast):
                loadedContentView(podcast: podcast)
            }
        }
    }
}

// MARK: - Loaded View Content
private extension PodcastDetailView {
    func loadedContentView(podcast: PodcastUIModel) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .zero) {
                image(podcast: podcast)
                    .offset(y: max(0, scrollOffset))

                PodcastDetailContentView(
                    podcast: podcast,
                    isScrolled: isScrolled,
                    episodeListState: viewModel.episodeListState,
                    fetchEpisodes: {
                        Task {
                            await viewModel.fetchData()
                        }
                    }
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
        .safeAreaInset(edge: .bottom) {
            if let episode = nowPlayingViewModel.currentlyPlayingEpisode {
                NowPlayingCompactView(episode: episode)
                    .transition(.move(edge: .bottom))
            }
        }
        .ignoresSafeArea(edges: .top)
    }

    func image(podcast: PodcastUIModel) -> some View {
        KFImage(podcast.imageURL)
            .resizable()
            .scaledToFill()
            .frame(height: imageHeight)
            .frame(maxWidth: .infinity)
            .clipped()
            .stretchy()
    }
}

// MARK: - Navigation Bar
private extension PodcastDetailView {
    func navigationBar(podcast: PodcastUIModel?) -> some View {
        HStack(alignment: .center, spacing: 12) {
            backButton

            navigationTitle(podcast: podcast)
                .frame(maxWidth: .infinity, alignment: .center)
                .opacity(showNavigationBackground ? 1 : 0)

            if let url = viewModel.getShareURL() {
                shareButton(url: url)
            } else {
                backButton
                    .hidden()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
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

    func shareButton(url: URL) -> some View {
        ShareLink(item: url) {
            navigationButtonLabel("square.and.arrow.up")
        }
        .buttonStyle(.plain)
    }

    var backButton: some View {
        Button {
            dismiss()
        } label: {
            navigationButtonLabel("chevron.left")
        }
        .buttonStyle(.plain)
    }

    func navigationButtonLabel(_ icon: String) -> some View {
        Image(systemName: icon)
            .foregroundStyle(.primary)
            .fontWeight(.regular)
            .padding()
            .background(.thickMaterial)
            .clipShape(.circle)
    }

    func navigationTitle(podcast: PodcastUIModel?) -> some View {
        Text(podcast?.title ?? "")
            .font(.headline)
            .foregroundStyle(.primary)
            .lineLimit(1)
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
        title: "The Rest Is History super long title for the podcast to test",
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
    .environment(NowPlayingViewModel())
}
