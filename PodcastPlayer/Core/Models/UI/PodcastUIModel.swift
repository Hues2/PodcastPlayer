//
//  PodcastUIModel.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 21/04/2026.
//

import Foundation

struct PodcastUIModel: Identifiable {
    let id: Int
    let title: String
    let author: String?
    let categoryIds: [Int]?
    let description: String?
    let imageURL: URL?
    let languageIso: String?
    let link: String?
    let popularity: Double?
    let rss: String?
    let seasonal: Bool
    let type: String?
}

extension PodcastUIModel {
    init?(_ dto: PodcastDTO) {
        guard let id = dto.id else { return nil }

        self.id = id
        self.title = dto.title ?? "Unknown Podcast"
        self.author = dto.author
        self.categoryIds = dto.categoryIds ?? []
        self.description = dto.description
        if let baseUrl: String = Utils.infoPlistValue(for: "API_BASE_URL"),
           let imageId = dto.image {
            self.imageURL = URL(string: "\(baseUrl)images/\(imageId)")
        } else {
            self.imageURL = nil
        }
        self.languageIso = dto.languageIso
        self.link = dto.link
        self.popularity = dto.popularity ?? 0
        self.rss = dto.rss
        self.seasonal = dto.seasonal ?? false
        self.type = dto.type
    }
}
