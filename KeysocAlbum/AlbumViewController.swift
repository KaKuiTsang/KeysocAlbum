//
//  ViewController.swift
//  KeysocAlbum
//
//  Created by Tsang Ka Kui on 3/8/2021.
//

import UIKit
import RxSwift
import RxCocoa

final class AlbumViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Album>
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Album>
    
    enum Section {
        case main
    }
    
    private let viewModel: AlbumViewModel
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
    private lazy var dataSource = createDataSource()
    private let disposeBag = DisposeBag()
    
    init(viewModel: AlbumViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureNavigationBar()
        configureCollectionView()
        layoutSubviews()
        setupRxActions()
    }
    
    private func configureNavigationBar() {
        title = "Album"
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
        viewModel.albumsObervable
            .withUnretained(self)
            .subscribe(onNext: { owner, albums in
                owner.applySnapshot(with: albums, animatingDifferences: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output
            .withUnretained(self)
            .subscribe(onNext: { owner, output in
                switch output {
                case let .reloadItems(albums):
                   var snapshot = owner.dataSource.snapshot()
                    snapshot.reloadItems(albums)
                    owner.dataSource.apply(snapshot, animatingDifferences: false)
                }
            })
            .disposed(by: disposeBag)

        collectionView.rx
            .itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                owner.viewModel.input.accept(.didTap(indexPath.item))
            })
            .disposed(by: disposeBag)
    }
}
