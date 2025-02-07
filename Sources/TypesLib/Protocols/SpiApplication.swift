//
//  SpiApplication.swift
//  types-lib
//
//  Created by Georgie Ivanov on 7.02.25.
//
import Vapor

struct SpiURLKey: StorageKey {
    public typealias Value = String
}

public protocol SpiApplication where Self: Application {
    var spiFullURLString: String? { get set }
}

public extension SpiApplication {
    
    
    var spiFullURLString: String? {
        get {
            self.storage[SpiURLKey.self]
        }
        set {
            self.storage[SpiURLKey.self] = newValue
        }
    }
    
}
