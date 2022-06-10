//
//  SearchViewController.swift
//  NetflixSample
//
//  Created by anies1212 on 2022/06/08.
//

import UIKit

class SearchViewController: UIViewController, UISearchControllerDelegate {
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    var models = [Title]()
    
    private let searchController: UISearchController = {
        let searchResultsVC = UISearchController(searchResultsController: SearchResultsViewController())
        searchResultsVC.hidesNavigationBarDuringPresentation = false
        searchResultsVC.searchBar.placeholder = "Search.."
        searchResultsVC.searchBar.searchBarStyle = .minimal
        searchResultsVC.definesPresentationContext = true
        return searchResultsVC
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        fetchDiscoverdMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func fetchDiscoverdMovies(){
        APICaller.shared.getDiscoveredMovies {[weak self] results in
            DispatchQueue.main.async {
                switch results {
                case .success(let movies):
                    self?.models = movies
                    self?.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as! TitleTableViewCell
        cell.configure(with: TitleViewModel(titleName: models[indexPath.row].original_title ?? "Unknown", posterURL: models[indexPath.row].poster_path ?? "", overview: models[indexPath.row].overview ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let title = models[indexPath.row].original_title ?? models[indexPath.row].original_name, let overview = models[indexPath.row].overview else {return}
        APICaller.shared.getYoutubeMovie(with: title) { [weak self] results in
            DispatchQueue.main.async {
                switch results {
                case .success(let videoElement):
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: title, overview: overview, youtubeVideo: videoElement))
                    self?.navigationController?.pushViewController(vc, animated: true)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController, let searchText = searchController.searchBar.text, !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        resultsController.delegate = self
        APICaller.shared.searchMovies(query: searchText) { results in
            switch results {
            case .success(let movies):
                resultsController.configure(with: movies)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension SearchViewController: SearchResultsViewControllerDelegate {
    
    func didSelectCollectionViewCell(_ model: Title) {
        print("model.original_title:\(model.original_title)")
        guard let title = model.original_title ?? model.original_name, let overview = model.overview else {return}
        APICaller.shared.getYoutubeMovie(with: title) { [weak self] results in
            DispatchQueue.main.async {
                switch results {
                case .success(let videoElement):
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: title, overview: overview, youtubeVideo: videoElement))
                    self?.navigationController?.pushViewController(vc, animated: true)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}
