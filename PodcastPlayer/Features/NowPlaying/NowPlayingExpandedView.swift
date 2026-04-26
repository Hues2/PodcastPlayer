//
//  NowPlayingExpandedView.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 23/04/2026.
//

import SwiftUI
import Kingfisher

struct NowPlayingExpandedView: View {
    let episode: EpisodeUIModel

    @Environment(NowPlayingViewModel.self) private var nowPlayingViewModel

    private enum Layout {
        static let imageCornerRadius: CGFloat = 16
        static let imageHeight: CGFloat = 350
        static let screenPadding: CGFloat = 24
    }

    var body: some View {
        content            
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

// MARK: - View Content
private extension NowPlayingExpandedView {
    var content: some View {
        VStack(alignment: .center, spacing: 32) {
            navigationbar
                .padding(.horizontal, -Layout.screenPadding + 8)

            VStack(alignment: .center, spacing: 16) {
                image
                infoView
                PlaybackControlsView()
                    .padding(.top, 8)
            }
        }
        .padding(Layout.screenPadding)
    }
}

// MARK: - Navigation Bar
private extension NowPlayingExpandedView {
    var navigationbar: some View {
        HStack(alignment: .center, spacing: .zero) {
            collapseButton
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    var collapseButton: some View {
        Button {
            nowPlayingViewModel.setIsNowPlayingExpanded(false)
        } label: {
            Image(systemName: "chevron.down")
                .font(.title3)
                .fontWeight(.regular)
                .foregroundStyle(.primary)
                .padding()
                .background(.ultraThickMaterial)
                .clipShape(.circle)
                .contentShape(.circle)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Image View
private extension NowPlayingExpandedView {
    var image: some View {
        KFImage(episode.podcastImageURL)
            .resizable()
            .scaledToFill()
            .frame(height: Layout.imageHeight)
            .frame(maxWidth: .infinity)
            .clipShape(.rect(cornerRadius: Layout.imageCornerRadius))
    }
}

// MARK: - Info View
private extension NowPlayingExpandedView {
    var infoView: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(episode.title)
                .font(.title3)
                .foregroundStyle(.primary)
                .fontWeight(.semibold)

            if let podcastTitle = episode.podcastTitle {
                Text(podcastTitle)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .fontWeight(.regular)
            }
        }
        .lineLimit(1)
    }
}

#Preview {
    let episode = EpisodeUIModel(
        id: 1,
        title: "The Fall of the Roman Empire some really long text to test long titles",
        description: "A deep dive into the fall of Rome.",
        duration: 3600,
        published: Date(),
        episode: 1,
        season: 1,
        type: "full",
        audioURL: nil,
        podcastTitle: "The Rest Is History",
        podcastImageURL: URL(string: "https://the-podcasts.fly.dev/v1/images/dd556fcd-1330-5c13-b86e-5a02b858bdba")
    )

    NowPlayingExpandedView(episode: episode)
        .environment(NowPlayingViewModel(currentlyPlayingEpisode: episode))
        .ignoresSafeArea()
}
