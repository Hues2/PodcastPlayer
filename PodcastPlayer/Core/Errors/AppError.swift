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
            return String(localized: "No Podcasts Found", table: "ErrorCatalog")
        case .default:
            return String(localized: "Oops, Something Went Wrong", table: "ErrorCatalog")
        }
    }

    var errorDescription: String? {
        switch self {
        case .custom(let message):
            return message
        case .noPodcastsAvailable:
            return String(localized: "We couldn't find any podcasts right now. Please try again later.", table: "ErrorCatalog")
        case .default:
            return String(localized: "An unexpected error occurred. Please try again.", table: "ErrorCatalog")
        }
    }
}
