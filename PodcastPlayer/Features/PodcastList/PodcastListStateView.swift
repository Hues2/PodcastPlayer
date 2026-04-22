//
//  PodcastListView.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 21/04/2026.
//

import SwiftUI

struct PodcastListStateView: View {
    @State private var viewModel = PodcastListViewModel()

    var body: some View {
        content
            .task { await viewModel.fetchPodcasts() }
    }
}

// MARK: - View Content
private extension PodcastListStateView {
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .idle:
            ProgressView()
        case .loading:
            ProgressView()
        case .error(let error):
            ErrorView(error: error) {
                Task {
                    await viewModel.fetchPodcasts()
                }
            }
        case .loaded(let model):
            PodcastListView(model: model)
        }
    }
}

#Preview {
    PodcastListStateView()
}
