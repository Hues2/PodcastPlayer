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
    case `default`

    var errorTitle: String? {
        switch self {
        case .custom(let title):
            return title
        case .noPodcastsAvailable:
            return String.error("No Podcasts Found")
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
        case .default:
            return String.error("An unexpected error occurred. Please try again.")
        }
    }
}
