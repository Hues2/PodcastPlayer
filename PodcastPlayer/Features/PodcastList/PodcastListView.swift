//
//  PodcastListView.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 21/04/2026.
//

import SwiftUI

struct PodcastListView: View {
    @State private var viewModel = PodcastListViewModel()

    var body: some View {
        Text("Podcast List View")
    }
}

#Preview {
    PodcastListView()
}
