//
//  File.swift
//  PodcastPlayerNetworkingKit
//
//  Created by Greg Ross on 21/04/2026.
//

import Foundation

public protocol NetworkService {
    func perform<R: NetworkRequest>(_ request: R) async throws -> R.Response
}
