//
//  FavoritesViewController.swift
//  MoviesApp
//
//  Created by Amanda Karolina Santos da Fonseca Paiva


import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: MoviesViewModel
    var onSelect: (Movie) -> Void

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            if viewModel.favoriteMovies.isEmpty {
                Text("Não há filmes favoritos no momento")
                    .font(.headline)
                    .foregroundColor(.secondary)
            } else {
                List {
                    ForEach(viewModel.favoriteMovies, id: \.id) { movie in
                        HStack(spacing: 12) {
                            if let url = URL(string: "https://image.tmdb.org/t/p/w200\(movie.posterPath)") {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 60, height: 90)
                                .cornerRadius(8)
                            }
                            VStack(alignment: .leading, spacing: 4) {
                                Text(movie.title)
                                    .font(.headline)
                                    .lineLimit(1)
                                Text(viewModel.formattedRating(for: movie))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                        .onTapGesture {
                            onSelect(movie)
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { viewModel.removeFavorite(at: $0) }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .navigationTitle("Favoritos")
        .onAppear {
            viewModel.loadFavoriteMovies()
        }
    }
}

final class FavoritesHostingController: UIHostingController<FavoritesView> {
    init(coordinator: MoviesCoordinator) {
        let vm = MoviesViewModel()
        let root = FavoritesView(viewModel: vm) { coordinator.showMovieDetail(movie: $0) }
        super.init(rootView: root)
    }
    @objc required dynamic init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
