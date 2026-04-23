//
//  PlayPauseButton.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 23/04/2026.
//

import SwiftUI

struct PlayPauseButton: View {
    var style: Style = .expanded

    @Environment(NowPlayingViewModel.self) private var nowPlayingViewModel

    enum Style {
        case expanded
        case compact

        var font: Font {
            switch self {
            case .expanded: .title
            case .compact: .title3
            }
        }

        var size: CGFloat {
            switch self {
            case .expanded: 72
            case .compact: 44
            }
        }
    }

    var body: some View {
        Button {
            guard !nowPlayingViewModel.isLoading else { return }
            nowPlayingViewModel.playPauseAction()
        } label: {
            Group {
                if nowPlayingViewModel.isLoading {
                    ProgressView()
                } else {
                    Image(systemName: nowPlayingViewModel.isPlaying ? "pause.fill" : "play.fill")
                }
            }
            .contentTransition(.symbolEffect(.replace))
            .font(style.font)
            .foregroundStyle(.primary)
            .frame(width: style.size, height: style.size)
            .background(.ultraThickMaterial)
            .clipShape(.circle)
        }
        .buttonStyle(.plain)
    }
}

#Preview("Expanded") {
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
        podcastImageURL: URL(string: "https://the-podcasts.fly.dev/v1/images/dd556fcd-1330-5c13-b86e-5a02b858bdba")
    )

    NowPlayingExpandedView(episode: episode)
        .environment(NowPlayingViewModel(currentlyPlayingEpisode: episode))
}

#Preview("Compact") {
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
        podcastImageURL: URL(string: "https://the-podcasts.fly.dev/v1/images/dd556fcd-1330-5c13-b86e-5a02b858bdba")
    )

    NowPlayingCompactView(episode: episode)
        .environment(NowPlayingViewModel(currentlyPlayingEpisode: episode))
}
