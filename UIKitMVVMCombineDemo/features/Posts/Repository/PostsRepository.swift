//
//  PostsRepository.swift
//  UIKitMVVMCombineDemo
//
//  Created by Prakash Maharjan on 20/06/2026.
//

import Combine

protocol PostsRepositoryProtocol {
    func fetchPosts(
        page: Int,
        limit: Int
    ) -> AnyPublisher<[Post], NetworkError>
}

final class PostsRepository: PostsRepositoryProtocol {

    private let network: NetworkServicing

    init(network: NetworkServicing = NetworkService.shared) {
        self.network = network
    }

    func fetchPosts(
        page: Int,
        limit: Int
    ) -> AnyPublisher<[Post], NetworkError> {

        do {
            let request = try PostsEndpoint.posts(
                page: page,
                limit: limit
            )

            return network.request(request)

        } catch let error as NetworkError {

            return Fail(error: error)
                .eraseToAnyPublisher()

        } catch {

            return Fail(error: .network(error))
                .eraseToAnyPublisher()
        }
    }
}
