//
//  Utils.swift
//  PodcastPlayer
//

import Foundation

enum Utils {
    static func infoPlistValue<T>(for key: String) -> T? {
        Bundle.main.infoDictionary?[key] as? T
    }
}
