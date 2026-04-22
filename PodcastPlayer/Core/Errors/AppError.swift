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

    var errorDescription: String? {
        switch self {
        case .custom(let message):
            return message
        case .noPodcastsAvailable:
            return String(localized: "No podcasts available", table: "ErrorCatalog")
        }
    }
}
