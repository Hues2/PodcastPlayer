//
//  File.swift
//  PodcastPlayerNetworkingKit
//
//  Created by Greg Ross on 21/04/2026.
//

import Foundation
import os

public final class NetworkServiceImpl: NetworkService {
    private let session: URLSession
    private let baseURL: String
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "NetworkService", category: "NetworkService")

    public init(baseURL: String, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    public func perform<R: NetworkRequest>(_ request: R) async throws -> R.Response {
        guard let url = URL(string: baseURL) else { throw NetworkError.invalidURL }
        let urlRequest = try request.asURLRequest(baseURL: url)

        logger.debug("Performing \(urlRequest.httpMethod ?? "UNKNOWN", privacy: .public) request to \(urlRequest.url?.absoluteString ?? "unknown", privacy: .public)")

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch {
            logger.error("Request failed: \(error.localizedDescription, privacy: .public)")
            throw NetworkError.unknown(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("Invalid response received")
            throw NetworkError.invalidResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            logger.error("HTTP error: status code \(httpResponse.statusCode, privacy: .public)")
            throw NetworkError.httpError(statusCode: httpResponse.statusCode, data: data)
        }

        do {
            return try request.decoder.decode(R.Response.self, from: data)
        } catch {
            logger.error("Decoding failed: \(error.localizedDescription, privacy: .public)")
            throw NetworkError.decodingError(error)
        }
    }
}
