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
        content
            .task { await viewModel.fetchPodcasts() }
    }
}

// MARK: - View Content
private extension PodcastListView {
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .idle:
            ProgressView()
        case .loading:
            ProgressView()
        case .error(let error):
            // TODO: Create error view
            Text("ERROR")
        case .loaded(let model):
            PodcastListLoadedView(model: model)
        }
    }
}

#Preview {
    PodcastListView()
}
