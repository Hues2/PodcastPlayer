//
//  Array.swift
//  PodcastPlayerDeeplinkKit
//
//  Created by Greg Ross on 27/04/2026.
//

import Foundation

extension Array where Element == String {
    func withAllSlashComponentsRemoved() -> [Element] { self.filter { $0 != "/" } }
}
