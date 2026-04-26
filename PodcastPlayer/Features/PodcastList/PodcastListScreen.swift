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
}
