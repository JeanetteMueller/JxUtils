//
//  DispatchQueue+saveMainThread.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 21.10.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import Foundation

extension DispatchQueue {
    class func mainSyncSafe(execute work: () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.sync(execute: work)
        }
    }
    
    class func mainSyncSafe<T>(execute work: () throws -> T) rethrows -> T {
        if Thread.isMainThread {
            return try work()
        } else {
            return try DispatchQueue.main.sync(execute: work)
        }
    }
}
