//
//  PlayPauseButton.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 23/04/2026.
//

import SwiftUI

struct PlayPauseButton: View {
    var font: Font = .title    

    @Environment(AudioPlayerViewModel.self) private var audioPlayerViewModel

    var body: some View {
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
            .font(font)
            .foregroundStyle(.primary)
            .padding()
            .background(.ultraThickMaterial)
            .clipShape(.circle)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PlayPauseButton()
}
