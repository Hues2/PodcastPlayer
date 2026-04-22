//
//  EpisodeUIModel.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 22/04/2026.
//

import Foundation

struct EpisodeUIModel: Identifiable, Hashable {
    let id: Int
    let title: String
    let description: String?
    let duration: Int?
    let published: Date?
    let episode: Int?
    let season: Int?
    let type: String?
    let audioURL: URL?
}

extension EpisodeUIModel {
    init?(_ dto: EpisodeDTO) {
        guard let id = dto.id else { return nil }

        self.id = id
        self.title = dto.title ?? "Unknown Episode"
        self.description = dto.description
        self.duration = dto.duration
        self.episode = dto.episode
        self.season = dto.season
        self.type = dto.type

        if let timestamp = dto.published {
            self.published = Date(timeIntervalSince1970: TimeInterval(timestamp))
        } else {
            self.published = nil
        }

        if let url = dto.url {
            self.audioURL = URL(string: url)
        } else {
            self.audioURL = nil
        }
    }
}
