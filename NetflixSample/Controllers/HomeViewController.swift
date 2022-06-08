//
//  HomeViewController.swift
//  NetflixSample
//
//  Created by anies1212 on 2022/06/08.
//

import UIKit

enum Section: Int {
    case trendingMovies = 0
    case trendingTVs = 1
    case popular = 2
    case upcomingMovies = 3
    case topRated = 4
}

class HomeViewController: UIViewController {
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    var trendingMovies = [Title]()
    var trendingTVs = [Title]()
    var populars = [Title]()
    var upcomingMovies = [Title]()
    var topRated = [Title]()
    private let sectionTitles = ["Trending Movies", "Trending TV", "Popular", "Upcoming Movies", "Top Rated"]
    override func viewDidLoad() {
        super.viewDidLoad()
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        let headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
        configureNavBar()
        fetchTrendingMovie()
        fetchTrendingTVs()
        fetchUpcomingMovies()
        fetchPopularMovies()
        fetchTopRatedMovies()
        view.addSubview(homeFeedTable)
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    private func configureNavBar(){
        let image = UIImage(named: "NetflixLogo")
        var resizedImage = image!.resized(toWidth: 35)
        resizedImage = resizedImage?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: resizedImage, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func fetchTrendingMovie(){
        APICaller.shared.getTrendingMovies {[weak self] results in
            DispatchQueue.main.async {
                switch results {
                case .success(let movies):
                    self?.trendingMovies = movies
                    self?.homeFeedTable.reloadData()
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            }
        }
    }
    
    private func fetchTrendingTVs(){
        APICaller.shared.getTrendingTVs {[weak self] results in
            DispatchQueue.main.async {
                switch results {
                case .success(let TVs):
                    self?.trendingTVs = TVs
                    self?.homeFeedTable.reloadData()
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    private func fetchUpcomingMovies(){
        APICaller.shared.getUpcomingMovies {[weak self] results in
            DispatchQueue.main.async {
                switch results {
                case .success(let upcomingMovies):
                    self?.upcomingMovies = upcomingMovies
                    self?.homeFeedTable.reloadData()
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func fetchPopularMovies(){
        APICaller.shared.getPopularMovies {[weak self] results in
            DispatchQueue.main.async {
                switch results {
                case .success(let movies):
                    self?.populars = movies
                    self?.homeFeedTable.reloadData()
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func fetchTopRatedMovies(){
        APICaller.shared.getTopRatedMovies {[weak self] results in
            DispatchQueue.main.async {
                switch results {
                case .success(let movies):
                    self?.topRated = movies
                    self?.homeFeedTable.reloadData()
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        }
    }


}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as! CollectionViewTableViewCell
        switch indexPath.section {
        case Section.trendingMovies.rawValue:
            cell.configure(with: trendingMovies)
        case Section.trendingTVs.rawValue:
            cell.configure(with: trendingTVs)
            break
        case Section.popular.rawValue:
            cell.configure(with: populars)
            break
        case Section.upcomingMovies.rawValue:
            cell.configure(with: upcomingMovies)
            break
        case Section.topRated.rawValue:
            cell.configure(with: topRated)
            break
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.textColor = .white
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x+10, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0,-offset))
    }
}
