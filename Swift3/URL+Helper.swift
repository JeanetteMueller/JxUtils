//
//  URL+Helper.swift
//  Podcat 2
//
//  Created by Jeanette Müller on 26.02.17.
//  Copyright © 2017 Jeanette Müller. All rights reserved.
//

import Foundation

extension URL {
    
    // Returns true if given file is a directory
    public var fileIsDirectory: Bool {
        var isdirv: AnyObject?
        do {
            try (self as NSURL).getResourceValue(&isdirv, forKey: URLResourceKey.isDirectoryKey)
        } catch _ {
        }
        return isdirv?.boolValue ?? false
    }
    
    // File modification date, nil if file doesn't exist
    public var fileModifiedDate: Date? {
        get {
            var datemodv: AnyObject?
            do {
                try (self as NSURL).getResourceValue(&datemodv, forKey: URLResourceKey.contentModificationDateKey)
            } catch _ {
            }
            return datemodv as? Date
        }
        set {
            do {
                try (self as NSURL).setResourceValue(newValue, forKey: URLResourceKey.contentModificationDateKey)
            } catch _ {
            }
        }
    }
    
    // File creation date, nil if file doesn't exist
    public var fileCreationDate: Date? {
        get {
            var datecreatev: AnyObject?
            do {
                try (self as NSURL).getResourceValue(&datecreatev, forKey: URLResourceKey.creationDateKey)
            } catch _ {
            }
            return datecreatev as? Date
        }
        set {
            do {
                try (self as NSURL).setResourceValue(newValue, forKey: URLResourceKey.creationDateKey)
            } catch _ {
            }
            
        }
    }
    
    // Returns last file access date, nil if file doesn't exist or not yet accessed
    public var fileAccessDate: Date? {
        _ = URLResourceKey.customIconKey
        var dateaccessv: AnyObject?
        do {
            try (self as NSURL).getResourceValue(&dateaccessv, forKey: URLResourceKey.contentAccessDateKey)
        } catch _ {
        }
        return dateaccessv as? Date
    }
    
    // Returns file size, -1 if file doesn't exist
    public var fileSize: Int64 {
        var sizev: AnyObject?
        do {
            try (self as NSURL).getResourceValue(&sizev, forKey: URLResourceKey.fileSizeKey)
        } catch _ {
        }
        return sizev?.int64Value ?? -1
    }
    
    // File is hidden or not, don't care about files beginning with dot
    public var fileIsHidden: Bool {
        get {
            var ishiddenv: AnyObject?
            do {
                try (self as NSURL).getResourceValue(&ishiddenv, forKey: URLResourceKey.isHiddenKey)
            } catch _ {
            }
            return ishiddenv?.boolValue ?? false
        }
        set {
            do {
                try (self as NSURL).setResourceValue(newValue, forKey: URLResourceKey.isHiddenKey)
            } catch _ {
            }
            
        }
    }
    
    // Checks if file is writable
    public var fileIsWritable: Bool {
        var isdirv: AnyObject?
        do {
            try (self as NSURL).getResourceValue(&isdirv, forKey: URLResourceKey.isWritableKey)
        } catch _ {
        }
        return isdirv?.boolValue ?? false
    }
    
    // Set SkipBackup attrubute of file or directory in iOS. return current state if no value is set
    public func skipBackupAttributeToItemAtURL(_ skip: Bool? = nil) -> Bool {
        let keys = [URLResourceKey.isDirectoryKey, URLResourceKey.fileSizeKey]
        let enumOpt = FileManager.DirectoryEnumerationOptions()
        if FileManager.default.fileExists(atPath: self.path) {
            if skip != nil {
                if self.fileIsDirectory {
                    let filesList = (try? FileManager.default.contentsOfDirectory(at: self, includingPropertiesForKeys: keys, options: enumOpt)) ?? []
                    for fileURL in filesList {
                        _ = fileURL.skipBackupAttributeToItemAtURL(skip)
                    }
                }
                do {
                    try (self as NSURL).setResourceValue(NSNumber(value: skip! as Bool), forKey: URLResourceKey.isExcludedFromBackupKey)
                    return true
                } catch _ {
                    return false
                }
            } else {
                let dict = try? (self as NSURL).resourceValues(forKeys: [URLResourceKey.isExcludedFromBackupKey])
                if  let key: AnyObject = dict?[URLResourceKey.isExcludedFromBackupKey] as AnyObject? {
                    return key.boolValue
                }
                return false
            }
        }
        return false
    }
}
