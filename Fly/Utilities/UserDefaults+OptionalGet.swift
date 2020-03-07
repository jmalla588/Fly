//
//  UserDefaults+OptionalGet.swift
//  Fly
//
//  Created by Janak Malla on 3/5/20.
//  Copyright © 2020 Janak Malla. All rights reserved.
//

import UIKit

extension UserDefaults {
    /// Convenience method to wrap the built-in .integer(forKey:) method in an optional returning nil if the key doesn't exist.
    func integerOptional(forKey: String) -> Int? {
        return self.object(forKey: forKey) as? Int
    }
    /// Convenience method to wrap the built-in .double(forKey:) method in an optional returning nil if the key doesn't exist.
    func doubleOptional(forKey: String) -> Double? {
        return self.object(forKey: forKey) as? Double
    }
    /// Convenience method to wrap the built-in .float(forKey:) method in an optional returning nil if the key doesn't exist.
    func floatOptional(forKey: String) -> Float? {
        return self.object(forKey: forKey) as? Float
    }
    /// Convenience method to wrap the built-in .bool(forKey:) method in an optional returning nil if the key doesn't exist.
    func boolOptional(forKey: String) -> Bool? {
        return self.object(forKey: forKey) as? Bool
    }
}
