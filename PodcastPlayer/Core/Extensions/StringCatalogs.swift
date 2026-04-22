//
//  StringCatalogs.swift
//  PodcastPlayer
//
//  Created by Greg Ross on 22/04/2026.
//

import SwiftUI

// MARK: - String + String Catalogs
extension String {
    static func podcastList(_ key: String.LocalizationValue) -> String {
        String(localized: key, table: "PodcastListCatalog")
    }

    static func podcastDetail(_ key: String.LocalizationValue) -> String {
        String(localized: key, table: "PodcastDetailCatalog")
    }

    static func error(_ key: String.LocalizationValue) -> String {
        String(localized: key, table: "ErrorCatalog")
    }
}

// MARK: - LocalizedStringResource + String Catalogs
extension LocalizedStringKey {
    static func podcastList(_ key: String.LocalizationValue) -> LocalizedStringKey {
        LocalizedStringKey(String.podcastList(key))
    }

    static func podcastDetail(_ key: String.LocalizationValue) -> LocalizedStringKey {
        LocalizedStringKey(String.podcastDetail(key))
    }

    static func error(_ key: String.LocalizationValue) -> LocalizedStringKey {
        LocalizedStringKey(String.error(key))
    }
}
