//
//  ViewController.swift
//  KeysocAlbum
//
//  Created by Tsang Ka Kui on 3/8/2021.
//

import UIKit
import RxSwift

class AlbumViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Album>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Album>
    
    enum Section {
        case main
    }
    
    private var collectionView: UICollectionView!
    private lazy var dataSource = createDataSource()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.dataSource = dataSource
        collectionView.backgroundColor = .white

        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        AlbumRepository.shared.fetchAlbum()
            .subscribe { [weak self] result in
                switch result {
                case let .success(album):
                    self?.applySnapshot(with: album, animatingDifferences: true)
                case let .failure(error):
                    print("error \(error)")
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func createDataSource() -> DataSource {
        let cell = UICollectionView.CellRegistration<AlbumCell, Album> { cell, indexPath, album in
            cell.configureCell(album: album)
        }
        
        return DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cell, for: indexPath, item: item)
        }
    }
    
    private func applySnapshot(with albums: [Album] ,animatingDifferences: Bool = false) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(albums)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 2)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 12
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
