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
    private let explicitImageView = UIImageView(image: UIImage(systemName: "e.square.fill"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        albumCoverImageView.contentMode = .scaleAspectFill
        albumCoverImageView.layer.cornerRadius = 4
        albumCoverImageView.layer.masksToBounds = true
        
        albumNameLabel.numberOfLines = 1
        albumNameLabel.lineBreakMode = .byTruncatingTail
        albumNameLabel.textColor = UIColor.white
        albumNameLabel.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        
        releaseYearLabel.textColor = UIColor.gray
        releaseYearLabel.font = UIFont.systemFont(ofSize: 17)
        
        explicitImageView.tintColor = UIColor.gray
        explicitImageView.isHidden = true
        
        contentView.addSubview(container)
        container.addSubview(albumCoverImageView)
        container.addSubview(albumNameLabel)
        container.addSubview(releaseYearLabel)
        container.addSubview(explicitImageView)
        
        container.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview().priority(.high)
        }
        
        albumCoverImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(container.snp.width)
        }
        
        albumNameLabel.snp.makeConstraints {
            $0.top.equalTo(albumCoverImageView.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(explicitImageView.snp.leading).offset(-5)
        }
        
        releaseYearLabel.snp.makeConstraints {
            $0.top.equalTo(albumNameLabel.snp.bottom).offset(2)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        explicitImageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.trailing.lessThanOrEqualToSuperview().offset(0)
            $0.centerY.equalTo(albumNameLabel.snp.centerY)
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
        
        explicitImageView.isHidden = !album.isExplicit
    }
}
