//
//  PodcastListScreen.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 21/04/2026.
//

import Foundation

enum PodcastListScreen: Screen {
    case podcastDetail(PodcastUIModel)
    case podcastDetailById(Int)

    func isPodcastDetail(id: Int) -> Bool {
        switch self {
        case .podcastDetail(let podcast): podcast.id == id
        case .podcastDetailById(let existingId): existingId == id
        }
    }
}

extension Optional where Wrapped == PodcastListScreen {
    func isPodcastDetail(id: Int) -> Bool {
        switch self {
        case .some(let screen): screen.isPodcastDetail(id: id)
        case .none: false
        }
    }
}
