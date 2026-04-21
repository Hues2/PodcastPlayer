//
//  PodcastDTO.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 21/04/2026.
//

import Foundation

struct PodcastDTO: Decodable {
    let author: String?
    let categoryIds: [Int]?
    let description: String?
    let id: Int?
    let image: String?
    let languageIso: String?
    let link: String?
    let original: Bool?
    let popularity: Double?
    let rss: String?
    let seasonal: Bool?
    let slug: String?
    let title: String?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case author
        case categoryIds = "category_id"
        case description
        case id
        case image
        case languageIso = "language_iso"
        case link
        case original
        case popularity
        case rss
        case seasonal
        case slug
        case title
        case type
    }
}
