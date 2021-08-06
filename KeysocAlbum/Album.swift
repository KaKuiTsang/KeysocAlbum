//
//  Album.swift
//  KeysocAlbum
//
//  Created by Tsang Ka Kui on 3/8/2021.
//

import Foundation

typealias Album = AlbumResponse.Album

struct AlbumResponse: Decodable {
    let resultCount: Int
    let results: [Album]
    
    final class Album: Decodable, Hashable {
        let collectionId: Int
        let collectionName: String
        let albumCoverImageUrl: String
        let collectionPrice: Double
        let trackCount: Int
        let releaseDate: Date
        
        private let collectionExplicitness: String
        var isExplicit: Bool {
            collectionExplicitness == "explicit" ? true : false
        }
        
        var isBookmarked = false
        
        enum CodingKeys: String, CodingKey {
            case collectionId
            case collectionName
            case albumCoverImageUrl = "artworkUrl100"
            case collectionPrice
            case collectionExplicitness
            case trackCount
            case releaseDate
        }
        
        static func == (lhs: AlbumResponse.Album, rhs: AlbumResponse.Album) -> Bool {
            return lhs.collectionId == rhs.collectionId && lhs.isBookmarked == rhs.isBookmarked
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(collectionId)
            hasher.combine(isBookmarked)
        }
    }
}
