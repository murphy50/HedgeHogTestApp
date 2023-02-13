//
//  Extension.swift
//  HedgehogApp
//
//  Created by murphy on 13.02.2023.
//

import Foundation

extension NSLock {
    @discardableResult
    func with<T>(_ block: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try block()
    }
}
