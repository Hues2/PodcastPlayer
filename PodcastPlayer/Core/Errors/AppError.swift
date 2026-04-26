//
//  AppError.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 22/04/2026.
//

import Foundation

enum AppError: LocalizedError {
    case custom(String)
    case noPodcastsAvailable
    case noEpisodesAvailable
    case invalidEpisodeURL
    case `default`

    var errorTitle: String? {
        switch self {
        case .custom(let title):
            return title
        case .noPodcastsAvailable:
            return String.error("No Podcasts Found")
        case .noEpisodesAvailable:
            return String.error("No Episodes Found")
        case .invalidEpisodeURL:
            return String.error("Unable to Play Episode")
        case .default:
            return String.error("Oops, Something Went Wrong")
        }
    }

    var errorDescription: String? {
        switch self {
        case .custom(let message):
            return message
        case .noPodcastsAvailable:
            return String.error("We couldn't find any podcasts right now. Please try again later.")
        case .noEpisodesAvailable:
            return String.error("We couldn't find any episodes for this podcast right now. Please try again later.")
        case .invalidEpisodeURL:
            return String.error("This episode's audio link is unavailable or invalid. Please try a different episode.")
        case .default:
            return String.error("An unexpected error occurred. Please try again.")
        }
    }
}
