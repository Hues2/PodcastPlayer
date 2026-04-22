//
//  ContentView.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 21/04/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var audioPlayerViewModel = AudioPlayerViewModel()

    var body: some View {
        PodcastListNavigationStack()
            .environment(audioPlayerViewModel)
    }
}

#Preview {
    ContentView()
}
