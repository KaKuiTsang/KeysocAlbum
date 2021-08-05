//
//  AlbumCell.swift
//  KeysocAlbum
//
//  Created by Tsang Ka Kui on 4/8/2021.
//

import UIKit
import SnapKit
import Kingfisher

class AlbumCell: UICollectionViewCell {
    private let container = UIView()
    private let albumCoverImageView = UIImageView()
    private let albumNameLabel = UILabel()
    private let releaseYearLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        albumCoverImageView.contentMode = .scaleAspectFill
        albumCoverImageView.layer.cornerRadius = 4
        albumCoverImageView.layer.masksToBounds = true
        
        albumNameLabel.text = "Hello World"
        albumNameLabel.numberOfLines = 1
        albumNameLabel.lineBreakMode = .byTruncatingTail
        albumNameLabel.textColor = UIColor.darkText
        albumNameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        releaseYearLabel.text = "1999"
        releaseYearLabel.textColor = UIColor.darkText
        releaseYearLabel.font = UIFont.systemFont(ofSize: 18)
        
        contentView.addSubview(container)
        container.addSubview(albumCoverImageView)
        container.addSubview(albumNameLabel)
        container.addSubview(releaseYearLabel)
        
        container.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview().priority(.high)
        }
        
        albumCoverImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(container.snp.width)
        }
        
        albumNameLabel.snp.makeConstraints {
            $0.top.equalTo(albumCoverImageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        releaseYearLabel.snp.makeConstraints {
            $0.top.equalTo(albumNameLabel.snp.bottom).offset(2)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(album: Album) {
        albumCoverImageView.kf.setImage(with: URL(string: album.albumCoverImageUrl))
        albumNameLabel.text = album.collectionName
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        releaseYearLabel.text = dateFormatter.string(from: album.releaseDate)
    }
}
