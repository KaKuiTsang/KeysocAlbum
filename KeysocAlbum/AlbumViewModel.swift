//
//  AlbumViewModel.swift
//  KeysocAlbum
//
//  Created by Tsang Ka Kui on 6/8/2021.
//

import Foundation
import RxSwift
import RxRelay

enum AlbumInput {
    case didTap(Int)
}

enum AlbumOutput {
    case reloadItems([Album])
}

final class AlbumViewModel {
    
    private let albumRepo: AlbumRepository
    
    private let disposeBag = DisposeBag()
    
    private let albums = BehaviorRelay<[Album]>(value: [])
    
    var albumsObervable: Observable<[Album]> {
        albums.asObservable()
    }
    
    let input = PublishRelay<AlbumInput>()
    
    let output = PublishRelay<AlbumOutput>()
    
    init(albumRepo: AlbumRepository) {
        self.albumRepo = albumRepo
        
        albumRepo
            .fetchAlbum()
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .subscribe { [unowned self] result in
                switch result {
                case var .success(albums):
                    albums.sort { $0.releaseDate > $1.releaseDate }
                    self.albums.accept(albums)
                case let .failure(error):
                    print("error \(error)")
                }
            }
            .disposed(by: disposeBag)
        
        input
            .withLatestFrom(albums) { ($0, $1)}
            .subscribe(onNext: { [unowned self] input, albums in
                switch input {
                case let .didTap(index):
                    let album = albums[index]
                    album.isBookmarked.toggle()
                    self.output.accept(.reloadItems([album]))
                }
            })
            .disposed(by: disposeBag)
    }
    
}
