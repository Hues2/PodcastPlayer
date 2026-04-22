//
//  PodcastListView.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 21/04/2026.
//

import SwiftUI

struct PodcastListRootView: View {
    @State private var viewModel = PodcastListViewModel()

    var body: some View {
        content
            .task { await viewModel.fetchPodcasts() }
    }
}

// MARK: - View Content
private extension PodcastListRootView {
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
            PodcastListLoadedView(model: model)
        }
    }
}

#Preview {
    PodcastListRootView()
}
