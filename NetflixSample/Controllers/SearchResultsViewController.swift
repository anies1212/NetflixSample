//
//  SearchResultsViewController.swift
//  NetflixSample
//
//  Created by anies1212 on 2022/06/09.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func didSelectCollectionViewCell(_ model: Title)
}

class SearchResultsViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width/3)-10, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        collectionView.isHidden = true
        return collectionView
    }()
    var models = [Title]()
    weak var delegate: SearchResultsViewControllerDelegate?
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No Results"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Results.."
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        view.addSubview(emptyLabel)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        emptyLabel.frame = CGRect(x: 0, y: -60, width: view.frame.size.width, height: 60)
        emptyLabel.center = view.center
    }
    
    private func showLabel(){
        if models.isEmpty {
            collectionView.isHidden = true
            emptyLabel.isHidden = false
        } else {
            collectionView.isHidden = false
            emptyLabel.isHidden = true
        }
    }
    
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as! TitleCollectionViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("didtapped")
        delegate?.didSelectCollectionViewCell(models[indexPath.row])
    }
    
    func configure(with models: [Title]){
        self.models = []
        DispatchQueue.main.async {[weak self] in
            self?.models = models
            self?.showLabel()
            self?.collectionView.reloadData()
            
        }
    }
    
}
