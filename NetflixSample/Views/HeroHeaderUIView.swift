//
//  HeroHeaderUIView.swift
//  NetflixSample
//
//  Created by anies1212 on 2022/06/08.
//

import UIKit
import SDWebImage

protocol HeroHeaderUIViewDelegate: AnyObject {
    func didTappedPlayButton(_ model: TitleViewModel)
    func didTappedDownloadButton(_ model: TitleViewModel)
}

class HeroHeaderUIView: UIView {
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var model : TitleViewModel?
    
    private let downlodButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var delegate: HeroHeaderUIViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradient()
        addSubview(playButton)
        playButton.addTarget(self, action: #selector(tappedPlayButton), for: .touchUpInside)
        addSubview(downlodButton)
        downlodButton.addTarget(self, action: #selector(tappedDownloadButton), for: .touchUpInside)
        applyConstraints()
    }
    
    @objc func tappedDownloadButton(){
        guard let model = model else {
            return
        }
        delegate?.didTappedDownloadButton(model)
    }
    
    @objc func tappedPlayButton(){
        guard let model = model else {return}
        delegate?.didTappedPlayButton(model)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
    private func addGradient(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        layer.addSublayer(gradientLayer)
        gradientLayer.frame = bounds
    }
    
    private func applyConstraints(){
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        NSLayoutConstraint.activate(playButtonConstraints)
        
        let downlodButtonConstraints = [
            downlodButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downlodButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downlodButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        NSLayoutConstraint.activate(downlodButtonConstraints)
    }
    
    func configure(with model: TitleViewModel){
        self.model = model
        let url = Constants.imageBaseURL + model.posterURL
        print("url:\(url)")
        heroImageView.sd_setImage(with: URL(string: url))
    }
    

}
