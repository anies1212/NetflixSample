//
//  SearchViewController.swift
//  NetflixSample
//
//  Created by anies1212 on 2022/06/08.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    var models = [Title]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Upcoming"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        fetchUpcoming()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0,-offset))
    }
    
    private func fetchUpcoming(){
        APICaller.shared.getUpcomingMovies {[weak self] results in
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

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as! TitleTableViewCell
        cell.configure(with: TitleViewModel(titleName: models[indexPath.row].original_title ?? "Unknown", posterURL: models[indexPath.row].poster_path ?? "" , overview: models[indexPath.row].overview ?? ""))
        cell.delegate = self
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

extension UpcomingViewController: TitleTableViewCellDelegate {
    
    func didTappedPlayTitleButton(_ cell: UITableViewCell) {
        print("DidTappedPlayButton")
    }
    
}
