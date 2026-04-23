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
    let setIsExpanded: (Bool) -> Void

    @Environment(AudioPlayerViewModel.self) private var audioPlayerViewModel

    private enum Layout {
        static let imageCornerRadius: CGFloat = 16
        static let imageHeight: CGFloat = 350
        static let screenPadding: CGFloat = 24
    }

    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(.background)
    }
}

// MARK: - View Content
private extension NowPlayingExpandedView {
    var content: some View {
        VStack(alignment: .center, spacing: 24) {
            navigationbar
                .padding(.horizontal, -Layout.screenPadding + 8)
            
            image
        }
        .padding(Layout.screenPadding)
    }

    var image: some View {
        KFImage(episode.podcastImageURL)
            .resizable()
            .scaledToFill()
            .frame(height: Layout.imageHeight)
            .frame(maxWidth: .infinity)
            .clipShape(.rect(cornerRadius: Layout.imageCornerRadius))
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
            setIsExpanded(false)
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

    NowPlayingExpandedView(episode: episode) { _ in }
        .environment(AudioPlayerViewModel(currentlyPlayingEpisode: episode))
}
