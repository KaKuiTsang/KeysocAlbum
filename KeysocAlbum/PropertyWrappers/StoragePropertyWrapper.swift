//
//  StoragePropertyWrapper.swift
//  KeysocAlbum
//
//  Created by Tsang Ka Kui on 6/8/2021.
//

import Foundation

@propertyWrapper
struct Storage<T: Codable> {
    private let key: String
    private let defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            (try? UserDefaults.standard.getObject(forKey: key, type: T.self)) ?? defaultValue
        }
        set {
            try? UserDefaults.standard.setObject(newValue, forKey: key)
        }
    }
}
