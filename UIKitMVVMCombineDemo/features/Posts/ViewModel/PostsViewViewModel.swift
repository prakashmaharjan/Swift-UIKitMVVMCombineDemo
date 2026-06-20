//
//  PostsViewViewModel.swift
//  UIKitMVVMCombineDemo
//
//  Created by PM on 25/10/2024.
//

import Foundation
import Combine

@MainActor
final class PostsViewViewModel {

    @Published private(set) var posts: [Post] = []

    @Published private(set) var isLoading = false
    @Published private(set) var isLoadingMore = false

    @Published private(set) var error: NetworkError?

    private let repository: PostsRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    private var currentPage = 1
    private let pageSize = 20
    private var hasMorePages = true

    private var isRequestInFlight = false

    init(
        repository: PostsRepositoryProtocol = PostsRepository()
    ) {
        self.repository = repository
    }

    // MARK: - Public API

    func loadInitial() {
        currentPage = 1
        hasMorePages = true
        posts.removeAll()
        error = nil

        loadNextPage()
    }

    func loadNextPage() {

        guard hasMorePages else { return }
        guard !isRequestInFlight else { return }

        isRequestInFlight = true
        error = nil

        if posts.isEmpty {
            isLoading = true
        } else {
            isLoadingMore = true
        }

        repository
            .fetchPosts(page: currentPage, limit: pageSize)
            .sink(
                receiveCompletion: { [weak self] completion in

                    guard let self else { return }

                    self.isLoading = false
                    self.isLoadingMore = false
                    self.isRequestInFlight = false

                    if case .failure(let error) = completion {
                        self.error = error
                    }
                },
                receiveValue: { [weak self] newPosts in

                    guard let self else { return }

                    self.posts.append(contentsOf: newPosts)

                    if newPosts.count < self.pageSize {
                        self.hasMorePages = false
                    } else {
                        self.currentPage += 1
                    }
                }
            )
            .store(in: &cancellables)
    }
}
