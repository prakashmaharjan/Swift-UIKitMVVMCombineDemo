//
//  PostEndpoint.swift
//  UIKitMVVMCombineDemo
//
//  Created by Prakash Maharjan on 20/06/2026.
//

import Foundation

enum PostsEndpoint {

    static func posts(
        page: Int,
        limit: Int
    ) throws -> URLRequest {

        var components = URLComponents(
            string: "https://jsonplaceholder.typicode.com/posts"
        )

        components?.queryItems = [
            URLQueryItem(name: "_page", value: "\(page)"),
            URLQueryItem(name: "_limit", value: "\(limit)")
        ]

        guard let url = components?.url else {
            throw NetworkError.badURL
        }

        return URLRequest(url: url)
    }
}
