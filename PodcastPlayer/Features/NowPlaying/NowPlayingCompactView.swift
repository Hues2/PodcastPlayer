//
//  PlayingPodcastView.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 22/04/2026.
//

import SwiftUI
import Kingfisher

struct NowPlayingCompactView: View {
    let episode: EpisodeUIModel
    let setIsExpanded: (Bool) -> Void
    
    @Environment(AudioPlayerViewModel.self) private var audioPlayerViewModel
    
    private enum Layout {
        static let imageCornerRadius: CGFloat = 8
        static let imageSize: CGFloat = 64
        static let padding: CGFloat = 24
    }
    
    var body: some View {
        content
            .compositingGroup()
            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: -2)
    }
}

private extension NowPlayingCompactView {
    var content: some View {
        HStack(alignment: .center, spacing: 12) {
            infoView
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(.rect)
                .onTapGesture {
                    setIsExpanded(true)
                }
            
            playPauseButton
        }
        .padding(Layout.padding)
        .background(.background)
        .fixedSize(horizontal: false, vertical: true)
        .ignoresSafeArea()
    }
    
    var infoView: some View {
        HStack(spacing: 12) {
            KFImage(episode.podcastImageURL)
                .resizable()
                .scaledToFill()
                .frame(width: Layout.imageSize, height: Layout.imageSize)
                .clipShape(RoundedRectangle(cornerRadius: Layout.imageCornerRadius))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(episode.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                if let podcastTitle = episode.podcastTitle {
                    Text(podcastTitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
        }
    }
    
    var playPauseButton: some View {
        Button {
            guard !audioPlayerViewModel.isLoading else { return }
            audioPlayerViewModel.playPauseAction()
        } label: {
            Group {
                if audioPlayerViewModel.isLoading {
                    ProgressView()
                } else {
                    Image(systemName: audioPlayerViewModel.isPlaying ? "pause.fill" : "play.fill")
                }
            }
            .contentTransition(.symbolEffect(.replace))
            .font(.title3)
            .foregroundStyle(.primary)
            .frame(maxHeight: .infinity)
            .frame(width: 40)
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
        podcastImageURL: URL(string: "https://the-podcasts.fly.dev/v1/images/dd556fcd-1330-5c13-b86e-5a02b858bdba")
    )
    
    NowPlayingCompactView(episode: episode) { _ in }
        .environment(AudioPlayerViewModel(currentlyPlayingEpisode: episode))
}
