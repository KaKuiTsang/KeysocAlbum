//
//  AlbumRepository.swift
//  KeysocAlbum
//
//  Created by Tsang Ka Kui on 3/8/2021.
//

import Foundation
import Alamofire
import RxSwift

class AlbumRepository {
    
    func fetchAlbum() -> Single<[Album]> {
        return Single<[Album]>.create { single in
            AF.request("https://itunes.apple.com/search?term=jack+johnson&entity=album")
                .responseData { response in
                    switch response.result {
                    case let .success(data):
                        do {
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .iso8601
                            let albumResponse = try decoder.decode(AlbumResponse.self, from: data)
                            single(.success(albumResponse.results))
                        } catch {
                            print(error)
                        }
                    case let .failure(error):
                        print(error)
                    }
                }
            
            return Disposables.create()
        }
    }
}
