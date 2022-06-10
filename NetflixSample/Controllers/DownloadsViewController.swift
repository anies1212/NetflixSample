//
//  DownloadsViewController.swift
//  NetflixSample
//
//  Created by anies1212 on 2022/06/08.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    private var models = [TitleItem]()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Downloads"
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        fetchDownlodedTitles()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: .main) {[weak self] _ in
            self?.fetchDownlodedTitles()
            self?.tableView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func fetchDownlodedTitles(){
        DataPersistenceManager.shared.fetchTitlesFromDatabase { [weak self] results in
            DispatchQueue.main.async {
                switch results {
                case .success(let titles):
                    print("titles:\(titles)")
                    self?.models = titles
                    self?.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
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
extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as! TitleTableViewCell
        let title = models[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: (title.original_title ?? title.original_name) ?? "Unknown", posterURL: title.poster_path ?? "", overview: title.overview ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            
            DataPersistenceManager.shared.deleteDownloadedTitle(model: models[indexPath.row]) {[weak self] results in
                DispatchQueue.main.async {
                    switch results {
                    case .success():
                        print("Deleted Downloded Title")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    self?.models.remove(at: indexPath.row)
                    self?.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        default:
            break
        }
    }
    
}
