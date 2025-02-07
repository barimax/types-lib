//
//  Application.swift
//  types-lib
//
//  Created by Georgie Ivanov on 7.02.25.
//
import Vapor

public extension Application {
    struct SpiKey: StorageKey {
        public typealias Value = String
    }
    
    var spiFullURLString: String? {
        get {
            self.storage[SpiKey.self]
        }
        set {
            self.storage[SpiKey.self] = newValue
        }
    }
}
