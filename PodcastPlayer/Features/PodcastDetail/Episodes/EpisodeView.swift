//
//  EpisodeView.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 22/04/2026.
//

import SwiftUI

struct EpisodeView: View {
    let episode: EpisodeUIModel

    @Environment(AudioPlayerViewModel.self) private var audioPlayerViewModel

    var body: some View {
        content
            .contentShape(.rect)
            .onTapGesture {
                audioPlayerViewModel.play(episode: episode)
            }
    }
}

private extension EpisodeView {
    var content: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(episode.title)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .lineLimit(2)

                if let description = episode.description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                }

                HStack(spacing: 12) {
                    if let published = episode.published {
                        Text(published, style: .date)
                    }

                    if let duration = episode.duration {
                        Text(formattedDuration(duration))
                    }
                }
                .font(.caption)
                .foregroundStyle(.tertiary)
                .padding(.top, 8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "play.circle.fill")
                .font(.title2)
                .foregroundStyle(Color.accentColor)
        }
        .padding(.vertical, 8)
    }

    func formattedDuration(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes) min"
    }
}

#Preview {
    EpisodeView(episode: EpisodeUIModel(
        id: 3,
        title: "Episode 3: The End",
        description: "A thrilling conclusion.",
        duration: 3600,
        published: Date().addingTimeInterval(-172800),
        episode: 3,
        season: 1,
        type: "full",
        audioURL: nil
    ))
}
