//
//  NetworkService.swift
//  UIKitMVVMCombineDemo
//
//  Created by PM on 25/10/2024.
//

import Foundation
import Combine

final class NetworkService: NetworkServicing,Sendable{

    static let shared = NetworkService()

    private let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        config.timeoutIntervalForResource = 30

        self.session = URLSession(configuration: config)
    }

    func request<T: Decodable>(
        _ request: URLRequest
    ) -> AnyPublisher<T, NetworkError> {

        session.dataTaskPublisher(for: request)
            .tryMap { output in

                guard let response = output.response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }

                guard (200...299).contains(response.statusCode) else {
                    throw NetworkError.httpError(response.statusCode)
                }

                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in

                switch error {
                case let networkError as NetworkError:
                    return networkError

                case let decodingError as DecodingError:
                    return .decoding(decodingError)

                default:
                    return .network(error)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
