//
//  PodcastListDTO.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 21/04/2026.
//

import Foundation

struct PodcastListDTO: Decodable {
    let results: [PodcastDTO]?
}
