//
//  Utils.swift
//  PodcastPlayer
//

import Foundation

enum Utils {
    static func infoPlistValue<T>(for key: String, in bundle: Bundle = .main) -> T? {
        bundle.infoDictionary?[key] as? T
    }
}
