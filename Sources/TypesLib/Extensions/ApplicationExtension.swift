//
//  ApplicationExtension.swift
//  types-lib
//
//  Created by Georgie Ivanov on 8.12.25.
//
import Vapor

public struct MyConfigurationKey: StorageKey {
    public typealias Value = AppConfig
}

public extension Application {
    var configuration: AppConfig? {
        get {
            self.storage[MyConfigurationKey.self]
        }
        set {
            self.storage[MyConfigurationKey.self] = newValue
        }
    }
    
}
