//
//  Application.swift
//  types-lib
//
//  Created by Georgie Ivanov on 7.02.25.
//
import Vapor

public extension Application {
    struct SpiURLKey: StorageKey {
        public typealias Value = String
    }
    
    var spiFullURLString: String? {
        get {
            self.storage[SpiURLKey.self]
        }
        set {
            self.storage[SpiURLKey.self] = newValue
        }
    }
    
}
