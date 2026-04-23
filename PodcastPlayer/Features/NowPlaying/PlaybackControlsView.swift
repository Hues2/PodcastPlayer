//
//  PlaybackControlsView.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 23/04/2026.
//

import SwiftUI

struct PlaybackControlsView: View {
    @Environment(AudioPlayerViewModel.self) private var audioPlayerViewModel

    var body: some View {
        content
    }
}

private extension PlaybackControlsView {
    var content: some View {
        VStack(alignment: .center, spacing: 24) {
            // TODO: Add seek bar

            playbackButtons
        }
    }

    var playbackButtons: some View {
        HStack(alignment: .center, spacing: 24) {
            skipButton(iconName: "arrow.counterclockwise", action: { })
            PlayPauseButton()
            skipButton(iconName: "arrow.clockwise", action: { })
        }
    }

    func skipButton(iconName: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Image(systemName: iconName)                
                .font(.title3)
                .foregroundStyle(.primary)
                .background(.ultraThickMaterial)
                .clipShape(.circle)
        }
        .buttonStyle(.plain)
        .disabled(audioPlayerViewModel.isLoading)
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
        audioURL: URL(string: "https://dts.podtrac.com/redirect.mp3/stitcher.simplecastaudio.com/f09b6967-f720-4383-a6cf-42d1f475bd95/episodes/3b1239f1-d76a-43ce-be1e-69b7adc2ad58/audio/128/default.mp3?aid=rss_feed&awCollectionId=f09b6967-f720-4383-a6cf-42d1f475bd95&awEpisodeId=3b1239f1-d76a-43ce-be1e-69b7adc2ad58&feed=mKn_QmLS"),
        podcastTitle: "The Rest Is History",
        podcastImageURL: URL(string: "https://the-podcasts.fly.dev/v1/images/dd556fcd-1330-5c13-b86e-5a02b858bdba")
    )
    
    PlaybackControlsView()
        .environment(AudioPlayerViewModel(currentlyPlayingEpisode: episode))
}
