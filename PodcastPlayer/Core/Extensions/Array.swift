//
//  Array.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 26/04/2026.
//

import Foundation

extension Array where Element == String {
    func withAllSlashComponentsRemoved() -> [Element] { self.filter { $0 != "/" } }
}
