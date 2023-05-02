//
//  UserDefaultsWrapper.swift
//  workout-stats
//
//  Created by Dominika Gajdová on 02.04.2023.
//

import Foundation

@propertyWrapper
struct UserDefaultWrapper<T> {
    let key: String
    let defaultValue: T
    let userDefaults: UserDefaults

    init(_ key: UserDefaultsProvider.Key, defaultValue: T, userDefaults: UserDefaults = UserDefaults.standard) {
        self.key = key.rawValue
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    var wrappedValue: T {
        get {
            guard let value = userDefaults.object(forKey: key) else {
                return defaultValue
            }
            return value as? T ?? defaultValue
        }
        set {
            if let value = newValue as? OptionalProtocol, value.isNil() {
                userDefaults.removeObject(forKey: key)
            } else {
                userDefaults.set(newValue, forKey: key)
            }
        }
    }
}

@propertyWrapper
struct UserDefaultOptionalWrapper<T> {
    let key: String
    let defaultValue: T?
    let userDefaults: UserDefaults

    init(_ key: UserDefaultsProvider.Key, defaultValue: T? = nil, userDefaults: UserDefaults = UserDefaults.standard) {
        self.key = key.rawValue
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    var wrappedValue: T? {
        get {
            guard let value = userDefaults.object(forKey: key) else {
                return defaultValue
            }
            return value as? T
        }
        set {
            if newValue == nil {
                userDefaults.removeObject(forKey: key)
            } else {
                userDefaults.set(newValue, forKey: key)
            }
        }
    }
}

@propertyWrapper
struct UserDefaultCodableWrapper<T: Codable> {
    let key: String
    let defaultValue: T?
    let userDefaults: UserDefaults
    let jsonDecoder = JSONDecoder()
    let jsonEncoder = JSONEncoder()

    init(_ key: UserDefaultsProvider.Key, defaultValue: T? = nil, userDefaults: UserDefaults = UserDefaults.standard) {
        self.key = key.rawValue
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    var wrappedValue: T? {
        get {
            guard let data = userDefaults.object(forKey: key) as? Data, let value = try? jsonDecoder.decode(T.self, from: data) else {
                return defaultValue
            }

            return value
        }
        set {
            if newValue == nil {
                userDefaults.removeObject(forKey: key)
            } else {
                do {
                    let data = try jsonEncoder.encode(newValue)
                    userDefaults.set(data, forKey: key)
                } catch let error {
                    logger.error("Saving codable to user defaults failed: \(error.localizedDescription)")
                }
            }
        }
    }
}

protocol OptionalProtocol {
    func isNil() -> Bool
}

extension Optional: OptionalProtocol {
    func isNil() -> Bool {
        return self == nil
    }
}
