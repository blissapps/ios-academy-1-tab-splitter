//
//  FeatureFlags.swift
//  Bliss_ex1
//
//  Created by João Barros on 29/10/2021.
//

import Foundation

public struct FeatureFlags {
    
    static let shared = FeatureFlags()
    
    var isUserDefaultsOn: Bool = false
    
    private init() {
    }
}
