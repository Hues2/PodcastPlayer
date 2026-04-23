//
//  PlaybackControlsView.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 23/04/2026.
//

import SwiftUI

struct PlaybackControlsView: View {
    @Environment(NowPlayingViewModel.self) private var nowPlayingViewModel
    @State private var isDragging = false
    @State private var dragValue: Double = .zero

    var body: some View {
        content
    }
}

// MARK: - View Content
private extension PlaybackControlsView {
    var content: some View {
        VStack(alignment: .center, spacing: 24) {            
            seekBar
            playbackButtons
        }
    }
}

// MARK: - Seek Bar
private extension PlaybackControlsView {
    var seekBar: some View {
        VStack(spacing: 8) {
            bar
            barInfo
        }
    }

    var bar: some View {
        Slider(
            value: isDragging ? $dragValue : .constant(nowPlayingViewModel.currentTime),
            in: 0...max(nowPlayingViewModel.duration, 1)
        ) { editing in
            if editing {
                dragValue = nowPlayingViewModel.currentTime
                isDragging = true
            } else {
                Task {
                    await nowPlayingViewModel.seekTo(seconds: dragValue)
                    isDragging = false
                }
            }
        }
        .tint(.primary)
        .disabled(nowPlayingViewModel.isLoading)
    }

    var barInfo: some View {
        HStack(alignment: .center, spacing: 8) {
            Text(formatTime(isDragging ? dragValue : nowPlayingViewModel.currentTime))
            Spacer()
            Text("-\(formatTime(isDragging ? max(nowPlayingViewModel.duration - dragValue, 0) : nowPlayingViewModel.remainingTime))")
        }
        .font(.caption)
        .foregroundStyle(.secondary)
        .monospacedDigit()
    }

    func formatTime(_ seconds: Double) -> String {
        guard seconds.isFinite, seconds >= 0 else { return "0:00" }
        let totalSeconds = Int(seconds)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let secs = totalSeconds % 60
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, secs)
        }
        return String(format: "%d:%02d", minutes, secs)
    }
}

// MARK: - Buttons
private extension PlaybackControlsView {
    var playbackButtons: some View {
        HStack(alignment: .center, spacing: 24) {
            skipButton(
                iconName: "arrow.counterclockwise",
                action: nowPlayingViewModel.skipBackward
            )
            PlayPauseButton()
            skipButton(
                iconName: "arrow.clockwise",
                action: nowPlayingViewModel.skipForward
            )
        }
    }

    func skipButton(iconName: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Image(systemName: iconName)
                .font(.title3)
                .foregroundStyle(.primary)
                .padding(12)
                .background(.ultraThickMaterial)
                .clipShape(.circle)
        }
        .buttonStyle(.plain)
        .disabled(nowPlayingViewModel.isLoading)
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
        .environment(NowPlayingViewModel(currentlyPlayingEpisode: episode))
}
