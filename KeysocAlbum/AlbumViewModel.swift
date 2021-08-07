//
//  AlbumViewModel.swift
//  KeysocAlbum
//
//  Created by Tsang Ka Kui on 6/8/2021.
//

import Foundation
import RxSwift
import RxRelay
import SwiftUI

enum AlbumInput {
    case didTap(Int)
}

enum AlbumOutput {
    case reloadItems([Album])
}

final class AlbumViewModel {
    
    private let albumRepo: AlbumRepository
    
    private let bookmarkRepo: BookmarkRepository
    
    private let disposeBag = DisposeBag()
    
    private let albums = BehaviorRelay<[Album]>(value: [])
    
    var albumsObervable: Observable<[Album]> {
        albums.asObservable()
    }
    
    let input = PublishRelay<AlbumInput>()
    
    let output = PublishRelay<AlbumOutput>()
    
    init(albumRepo: AlbumRepository, bookmarkRepo: BookmarkRepository) {
        self.albumRepo = albumRepo
        self.bookmarkRepo = bookmarkRepo
        
        albumRepo
            .fetchAlbum()
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .asObservable()
            .withLatestFrom(bookmarkRepo.bookmarks) { ($0, $1) }
            .subscribe { [unowned self] (albums, bookmarks) in
                var albums = albums
                albums.sort { $0.releaseDate > $1.releaseDate }
                albums.forEach { $0.isBookmarked = bookmarks.contains($0) }
                self.albums.accept(albums)
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
                    
                    if album.isBookmarked {
                        self.bookmarkRepo.addBookmarks(album)
                    } else {
                        self.bookmarkRepo.removeBookmark(album)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
}
