//
//  BillItem.swift
//  BillSplitterApp
//
//  Created by Filipe Santo on 30/09/2021.
//

import Foundation
import UIKit
//
import AmountValue

public struct Version: Codable, Hashable {
    let major: Int
    let minor: Int
    let revision: Int
    let patch: Int
}

public protocol Versionable {
    static var version: Version { get }
    var _version: Version { get }
}

public struct BillItem: Equatable, Codable, Versionable {

    enum CodingKeys: CodingKey {
        case version
        case id
        case name
        case amount
        case changedUser
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let version = try container.decode(Version.self, forKey: .version)
        let id = try container.decode(String.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let amount = try container.decode(AmountValue.self, forKey: .amount)
        let changedUser = try container.decode(Bool.self, forKey: .changedUser)
        if BillItem.version != version {
            //Do update
            self.id = id
            self.name = name
            self.amount = amount
            self.changedUser = changedUser
            _version = BillItem.version
        } else {
            self.id = id
            self.name = name
            self.amount = amount
            self.changedUser = changedUser
            self._version = version
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_version, forKey: .version)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(amount, forKey: .amount)
        try container.encode(changedUser, forKey: .changedUser)
    }

    public static var version: Version { Version(major: 1, minor: 0, revision: 0, patch: 0) }
    public var _version: Version
    private(set) public var id: String
    public var name: String?
    public var amount: AmountValue?
    public var changedUser: Bool?
    
    public init (name: String, amount: AmountValue, changedUser: Bool) {
        id = UUID().uuidString
        self.name = name
        self.amount  = amount
        self.changedUser = changedUser
        _version = BillItem.version
    }
}
