//
//  File.swift
//  PodcastPlayerNetworkingKit
//
//  Created by Greg Ross on 21/04/2026.
//

import Foundation

public final class NetworkServiceImpl: NetworkService {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func perform<R: NetworkRequest>(_ request: R) async throws -> R.Response {
        let urlRequest = try request.asURLRequest()

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch {
            throw NetworkError.unknown(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode, data: data)
        }

        do {
            return try request.decoder.decode(R.Response.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
