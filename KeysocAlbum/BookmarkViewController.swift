//
//  BookmarkViewController.swift
//  KeysocAlbum
//
//  Created by Tsang Ka Kui on 6/8/2021.
//

import UIKit
import RxSwift

final class BookmarkViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Album>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Album>
    
    enum Section {
        case main
    }
    
    private let bookmarkRepo = BookmarkRepository.shared
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
    private lazy var dataSource = createDataSource()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureNavigationBar()
        configureCollectionView()
        layoutSubviews()
        setupRxActions()
    }
    
    private func configureNavigationBar() {
        title = "Bookmark"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    private func layoutSubviews() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = dataSource
        collectionView.backgroundColor = .black
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
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(16)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        section.interGroupSpacing = 16
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func setupRxActions() {
        bookmarkRepo.bookmarks
            .withUnretained(self)
            .subscribe(onNext: { owner, bookmarks in
                var bookmarks = bookmarks
                bookmarks.sort { $0.releaseDate > $1.releaseDate }
                bookmarks.forEach { $0.isBookmarked = true }
                owner.applySnapshot(with: bookmarks, animatingDifferences: true)
            })
            .disposed(by: disposeBag)
    }
}
