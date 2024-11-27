//
//  CompanyPartner.swift
//  types-lib
//
//  Created by Georgie Ivanov on 27.11.24.
//
import Vapor
open class PartnerCodable: NSObject, Codable {
    open var name: String
    open var uid: String
    open var address: String?
    open var configuration: PartnerConfiguration
    
    public init(name: String, uid: String, address: String, configuration: PartnerConfiguration) {
        self.name = name
        self.uid = uid
        self.address = address
        self.configuration = configuration
    }
}
