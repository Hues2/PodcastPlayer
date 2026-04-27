//
//  Deeplink.swift
//  PodcastPlayerDeeplinkKit
//
//  Created by Greg Ross on 27/04/2026.
//

import Foundation

public enum Deeplink {
    case podcast(id: Int)

    // MARK: - URI Scheme
    public static let uriScheme: String = "podcastplayer"

    // MARK: - URL Hosts
    public static let podcastURLHost: String = "podcasts"
}

extension Deeplink {
    public init?(url: URL) {
        guard url.scheme == Self.uriScheme,
              let urlHost = url.host else { return nil }

        let pathComponents = url.pathComponents.withAllSlashComponentsRemoved()

        switch urlHost {
        case Self.podcastURLHost:
            guard let id = Self.getPodcastId(pathComponents) else { return nil }
            self = .podcast(id: id)
        default:
            // Deeplink host did not match any of the expected hosts
            return nil
        }
    }
}

// MARK: Helper methods
private extension Deeplink {
    static func getPodcastId(_ pathComponents: [String]) -> Int? {
        return Int(pathComponents.first ?? "")
    }
}
