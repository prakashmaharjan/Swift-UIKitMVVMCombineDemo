//
//  APIError.swift
//  UIKitMVVMCombineDemo
//
//  Created by Prakash Maharjan on 20/06/2026.
//

import Foundation

enum NetworkError: LocalizedError {
    case badURL
    case invalidResponse
    case httpError(Int)
    case decoding(Error)
    case network(Error)

    var errorDescription: String? {
        switch self {
        case .badURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .httpError(let code):
            return "Server returned \(code)"
        case .decoding(let error):
            return error.localizedDescription
        case .network(let error):
            return error.localizedDescription
        }
    }
}
