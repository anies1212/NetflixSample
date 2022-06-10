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
    
    private var randomTrendingMovie: Title?
    
    private var headerView: HeroHeaderUIView?
    
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
        configureNavBar()
        fetchTrendingMovie()
        fetchTrendingTVs()
        fetchUpcomingMovies()
        fetchPopularMovies()
        fetchTopRatedMovies()
        configureHeaderHeroView()
        view.addSubview(homeFeedTable)
        view.backgroundColor = .systemBackground
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    private func configureHeaderHeroView(){
        APICaller.shared.getTrendingMovies {[weak self] results in
            guard let strongSelf = self else {return}
            DispatchQueue.main.async {
                switch results {
                case .success(let movies):
                    strongSelf.randomTrendingMovie = movies.randomElement()
                    strongSelf.headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: strongSelf.view.frame.size.width, height: 450))
                    strongSelf.headerView?.delegate = self
                    guard let title = strongSelf.randomTrendingMovie?.original_title else {return}
                    guard let url = strongSelf.randomTrendingMovie?.poster_path else {return}
                    guard let overview = strongSelf.randomTrendingMovie?.overview else {return}
                    strongSelf.headerView?.configure(with: TitleViewModel(titleName: title, posterURL: url, overview: overview))
                    strongSelf.homeFeedTable.tableHeaderView = strongSelf.headerView
                    self?.homeFeedTable.reloadData()
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            }
        }
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

extension HomeViewController: HeroHeaderUIViewDelegate {
    
    func didTappedPlayButton(_ model: TitleViewModel) {
        
        APICaller.shared.getYoutubeMovie(with: model.titleName) { [weak self] results in
            DispatchQueue.main.async {
                switch results {
                case .success(let video):
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: model.titleName, overview: model.overview, youtubeVideo: video))
                    self?.navigationController?.pushViewController(vc, animated: true)
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    }
    
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    
    func didTappedCollectionViewCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async {[weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func didTappedDownloadButton(_ model: TitleViewModel) {

        DataPersistenceManager.shared.dowloadTitle(with: Title(id: randomTrendingMovie?.id ?? 0, media_type: randomTrendingMovie?.media_type, original_name: randomTrendingMovie?.original_name, original_title: randomTrendingMovie?.original_title ?? randomTrendingMovie?.original_name ?? "", poster_path: randomTrendingMovie?.poster_path, overview: randomTrendingMovie?.overview, vote_count: randomTrendingMovie?.vote_count ?? 0, release_date: randomTrendingMovie?.release_date, vote_average: randomTrendingMovie?.vote_average ?? 0)) { results in
            switch results {
            case .success(()):
                print("Download Succeeded")
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
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
            cell.delegate = self
        case Section.trendingTVs.rawValue:
            cell.configure(with: trendingTVs)
            cell.delegate = self
            break
        case Section.popular.rawValue:
            cell.configure(with: populars)
            cell.delegate = self
            break
        case Section.upcomingMovies.rawValue:
            cell.configure(with: upcomingMovies)
            cell.delegate = self
            break
        case Section.topRated.rawValue:
            cell.configure(with: topRated)
            cell.delegate = self
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
