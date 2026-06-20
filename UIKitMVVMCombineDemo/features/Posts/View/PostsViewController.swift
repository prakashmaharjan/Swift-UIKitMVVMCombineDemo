//
//  PostsViewController.swift
//  UIKitMVVMCombineDemo
//
//  Created by PM on 25/10/2024.
//

import UIKit
import Combine

final class PostsViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        table.refreshControl = UIRefreshControl()
        table.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return table
    }()

    private let viewModel = PostsViewViewModel()
    private var cancellables = Set<AnyCancellable>()

    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let footerLoader = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Posts"

        setupUI()
        setupBindings()

        viewModel.loadInitial()
    }

    private func setupUI() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.register(PostTableViewCell.self,
                           forCellReuseIdentifier: PostTableViewCell.identifier)

        footerLoader.hidesWhenStopped = true
        tableView.tableFooterView = footerLoader

        setupLoadingIndicator()
    }

    private func setupLoadingIndicator() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupBindings() {

        viewModel.$posts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }

                if isLoading && self.viewModel.posts.isEmpty {
                    self.loadingIndicator.startAnimating()
                    self.tableView.isHidden = true
                } else {
                    self.loadingIndicator.stopAnimating()
                    self.tableView.isHidden = false
                    self.tableView.refreshControl?.endRefreshing()
                }
            }
            .store(in: &cancellables)

        viewModel.$isLoadingMore
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoadingMore in
                guard let self else { return }

                if isLoadingMore {
                    self.footerLoader.startAnimating()
                } else {
                    self.footerLoader.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }

    @objc private func handleRefresh() {
        viewModel.loadInitial()
    }
}


extension PostsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        viewModel.posts.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PostTableViewCell.identifier,
            for: indexPath
        ) as? PostTableViewCell else {
            return UITableViewCell()
        }
        
        let rowIndex = indexPath.row

        let post = viewModel.posts[rowIndex]
        cell.configure(with: post)

        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        print("tapped:", indexPath.row)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height

        let threshold = contentHeight - frameHeight * 2

        guard offsetY > threshold else { return }

        viewModel.loadNextPage()
    }
}
