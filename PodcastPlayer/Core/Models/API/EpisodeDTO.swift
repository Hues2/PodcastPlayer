//
//  EpisodeDTO.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 22/04/2026.
//

import Foundation

struct EpisodeDTO: Decodable {
    let id: Int?
    let title: String?
    let description: String?
    let duration: Int?
    let encoded: String?
    let episode: Int?
    let exclusive: Bool?
    let mimeType: String?
    let podcastId: Int?
    let published: Int?
    let season: Int?
    let slug: String?
    let type: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case duration
        case encoded
        case episode
        case exclusive
        case mimeType = "mime_type"
        case podcastId = "podcast_id"
        case published
        case season
        case slug
        case type
        case url
    }
}
