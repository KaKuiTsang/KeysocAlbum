//
//  ObjectSavable.swift
//  KeysocAlbum
//
//  Created by Tsang Ka Kui on 6/8/2021.
//

import Foundation

protocol ObjectSavable {
    func setObject<Object: Encodable>(_ object: Object, forKey key: String) throws
    func getObject<Object: Decodable>(forKey key: String, type: Object.Type) throws -> Object
}
