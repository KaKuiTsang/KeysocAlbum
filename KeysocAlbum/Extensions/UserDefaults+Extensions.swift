//
//  UserDefaults+Extensions.swift
//  KeysocAlbum
//
//  Created by Tsang Ka Kui on 6/8/2021.
//

import Foundation

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}

extension UserDefaults: ObjectSavable {
    
    func setObject<Object: Encodable>(_ object: Object, forKey key: String) throws {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: key)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Object: Decodable>(forKey key: String, type: Object.Type) throws -> Object  {
        guard let data = data(forKey: key) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}
