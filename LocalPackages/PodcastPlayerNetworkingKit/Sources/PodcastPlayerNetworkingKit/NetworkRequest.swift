//
//  File.swift
//  PodcastPlayerNetworkingKit
//
//  Created by Greg Ross on 21/04/2026.
//

import Foundation

public protocol NetworkRequest {
    associatedtype Response: Decodable
    
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Encodable? { get }
    var decoder: JSONDecoder { get }
}

extension NetworkRequest {
    public var headers: [String: String]? { nil }
    public var queryItems: [URLQueryItem]? { nil }
    public var body: Encodable? { nil }
    public var decoder: JSONDecoder { JSONDecoder() }

    public func asURLRequest() throws -> URLRequest {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true)
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        if let body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        return request
    }
}
