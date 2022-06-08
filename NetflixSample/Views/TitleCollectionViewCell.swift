//
//  TitleCollectionViewCell.swift
//  NetflixSample
//
//  Created by anies1212 on 2022/06/08.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleCollectionViewCell"
    let baseURL = "https://image.tmdb.org/t/p/w500"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    func configure(with model: Title){
        guard let posterURL = model.poster_path else {return}
        posterImageView.sd_setImage(with: URL(string: baseURL + posterURL))
    }
    
}
