//
//  TitleTableViewCell.swift
//  NetflixSample
//
//  Created by anies1212 on 2022/06/09.
//

import UIKit
import SDWebImage

protocol TitleTableViewCellDelegate: AnyObject {
    func didTappedPlayTitleButton(_ cell: UITableViewCell)
}

class TitleTableViewCell: UITableViewCell {
    
    static let identifier = "TitleTableViewCell"
    weak var delegate : TitleTableViewCellDelegate?
    
    private let playTitleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let buttonImage = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .black
        contentView.addSubview(titleImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playTitleButton)
        playTitleButton.addTarget(self, action: #selector(didTappedPlay), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyConstraints()
    }
    
    @objc func didTappedPlay(){
        let currentCell = self
        delegate?.didTappedPlayTitleButton(currentCell)
    }
    
    func configure(with model: TitleViewModel){
        let baseURL = Constants.imageBaseURL
        let imageURL = model.posterURL
        titleImageView.sd_setImage(with: URL(string:baseURL + imageURL))
        titleLabel.text = model.titleName
    }
    
    private func applyConstraints(){
        let titleImageViewConstraints = [
            titleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            titleImageView.widthAnchor.constraint(equalToConstant: 100)
        ]
        NSLayoutConstraint.activate(titleImageViewConstraints)
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: titleImageView.trailingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60)
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
        
        let playTitleButtonConstraints = [
            playTitleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playTitleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        NSLayoutConstraint.activate(playTitleButtonConstraints)
    }

}
