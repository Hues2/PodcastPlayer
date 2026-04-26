//
//  Deeplink.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 26/04/2026.
//

import Foundation

enum Deeplink {
    case podcast(id: Int)

    static let podcastURLHost: String = "podcasts"
}

extension Deeplink {
    init?(url: URL) {
        guard let uriScheme: String = Utils.infoPlistValue(for: "URI_SCHEME"),
              url.scheme == uriScheme,
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
