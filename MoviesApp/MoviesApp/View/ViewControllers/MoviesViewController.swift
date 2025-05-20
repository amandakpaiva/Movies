//
//  ViewController.swift
//  MoviesApp
//
//  Created by Amanda Karolina Santos da Fonseca Paiva

import UIKit

final class MoviesViewController: UIViewController, UITableViewDelegate {
    var coordinator: MoviesCoordinator?
    private lazy var viewModel: MoviesViewModel = MoviesViewModel()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "search_movies".localized
        searchBar.delegate = self
        return searchBar
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        configureRefreshControl(for: tableView)
        return tableView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
        return refreshControl
    }()

    init(viewModel: MoviesViewModel = MoviesViewModel(), coordinator: MoviesCoordinator?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.coordinator = coordinator
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchMovies()
    }

    private func setupUI() {
        title = "movies_title".localized
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = createHeartButton(title: "favorites_title".localized, target: self, action: #selector(showFavorites))
        navigationItem.titleView = searchBar

        view.addSubview(tableView)
        tableView.frame = view.bounds
    }

    private func configureRefreshControl(for tableView: UITableView) {
        tableView.refreshControl = refreshControl
    }

    @objc private func showFavorites() {
        coordinator?.navigateToFavorites()
    }

    @objc private func refreshMovies() {
        viewModel.fetchMovies()
    }

    private func bindViewModel() {
        viewModel.onMoviesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }

        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                AlertManager.showAlert(on: self!, title: "error_title".localized, message: errorMessage)
                self?.refreshControl.endRefreshing()
            }
        }
    }
}

// MARK: - UISearchBarDelegate
extension MoviesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchMovies(with: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource
extension MoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredMovies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
            return UITableViewCell()
        }

        let movie = viewModel.filteredMovies[indexPath.row]
        cell.configure(with: movie, viewModel: viewModel, indexPath: indexPath)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = viewModel.filteredMovies[indexPath.row]
        coordinator?.showMovieDetail(movie: selectedMovie)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let movie = viewModel.filteredMovies[indexPath.row]
        let addFavoriteAction = UIContextualAction(
            style: .normal,
            title: "favorite_action".localized
        ) { [weak self] _, _, completion in
            guard let self = self else {
                completion(false)
                return
            }

            self.viewModel.addFavorite(movie: movie)
            completion(true)

            DispatchQueue.main.async {
                let alert = UIAlertController( 
                    title: "favorite_added".localized,
                    message: "",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(
                    title: "Ok".localized,
                    style: .default
                ))
                self.present(alert, animated: true)
            }
        }
        addFavoriteAction.backgroundColor = .systemGreen

        return UISwipeActionsConfiguration(actions: [addFavoriteAction])
    }
}

