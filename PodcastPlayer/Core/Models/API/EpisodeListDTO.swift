//
//  EpisodeListDTO.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 22/04/2026.
//

import Foundation

struct EpisodeListDTO: Decodable {
    let results: [EpisodeDTO]?
}
