//
//  BookmarkRepository.swift
//  KeysocAlbum
//
//  Created by Tsang Ka Kui on 7/8/2021.
//

import Foundation
import RxSwift
import RxRelay

class BookmarkRepository {
    
    static let shared = BookmarkRepository()
    
    @Storage(key: "bookmarks", defaultValue: [Album]())
    private var bookmarkStorage
    
    private let _bookmarks = BehaviorRelay<[Album]>(value: [])
    
    var bookmarks: Observable<[Album]> {
        _bookmarks.asObservable()
    }
    
    private init() {
        _bookmarks.accept(bookmarkStorage)
    }
    
    func addBookmarks(_ album: Album) {
        var storedBookmarks = bookmarkStorage
        storedBookmarks.append(album)
        bookmarkStorage = storedBookmarks
        _bookmarks.accept(storedBookmarks)
    }
    
    func removeBookmark(_ album: Album) {
        var storedBookmarks = bookmarkStorage
        guard let index = storedBookmarks.firstIndex(of: album) else { return }
        storedBookmarks.remove(at: index)
        bookmarkStorage = storedBookmarks
        _bookmarks.accept(storedBookmarks)
    }
}
