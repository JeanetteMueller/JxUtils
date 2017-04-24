//
//  JxCoreDataStoreWithSync.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 20.10.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Ensembles

class JxCoreDataStoreWithSync: JxCoreDataStore, CDEPersistentStoreEnsembleDelegate {
    
    var ensemble: CDEPersistentStoreEnsemble?
    
    func enableSync(){
        
        CDESetCurrentLoggingLevel(CDELoggingLevel.warning.rawValue)// verbose.rawValue)
        
        let modelURL = Bundle.main.url(forResource: self.name, withExtension: "momd")
        
        
        let storeURL = self.storeURL()

        
        
        // Setup Ensemble
        let cloudFileSystem = CDEICloudFileSystem(ubiquityContainerIdentifier: nil)
        ensemble = CDEPersistentStoreEnsemble(ensembleIdentifier: self.name, persistentStore: storeURL, managedObjectModelURL: modelURL!, cloudFileSystem: cloudFileSystem)
        ensemble?.delegate = self
        

        
        // Listen for local saves, and trigger merges
        NotificationCenter.default.addObserver(self, selector:#selector(localSaveOccurred(_:)), name:NSNotification.Name.CDEMonitoredManagedObjectContextDidSave, object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(cloudDataDidDownload(_:)), name:NSNotification.Name.CDEICloudFileSystemDidDownloadFiles, object:nil)
        
    }

    // MARK: Notification Handlers
    
    func localSaveOccurred(_ notif: Notification) {
        print("is mainthread", Thread.isMainThread)
        self.sync { (info) in
            print("JxCoreDataStore sync completion: localSaveOccurred")
        }
    }
    
    func cloudDataDidDownload(_ notif: Notification) {
        print("is mainthread", Thread.isMainThread)
        self.sync{ (info) in
            print("JxCoreDataStore sync completion: cloudDataDidDownload")
        }
    }
    
    // MARK: Ensembles
    
    var syncing = false
    
    func sync(_ completion: ((Void) -> Void)?) {
        DispatchQueue.main.async {
            if !self.syncing{
                
                if let e = self.ensemble{
                    
                    if e.isMerging == false{
                        
                        self.syncing = true
                        
                        if !e.isLeeched {
                            
                            e.leechPersistentStore { error in
                                self.syncing = false
                                if error != nil{
                                    print("Could not leech to ensemble: ", error as Any)
                                }
                                completion?()
                            }
                        } else {
                            e.merge { error in
                                self.syncing = false
                                if error != nil{
                                    print("Could not merge to ensemble: ", error as Any)
                                }
                                completion?()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func persistentStoreEnsemble(_ ensemble: CDEPersistentStoreEnsemble, didSaveMergeChangesWith notification: Notification) {
        print("is mainthread", Thread.isMainThread)
        
        self.performForegroundTask { (context) in
            context.mergeChanges(fromContextDidSave: notification)
        }

    }
    
    func persistentStoreEnsemble(_ ensemble: CDEPersistentStoreEnsemble!, globalIdentifiersForManagedObjects objects: [Any]!) -> [Any]! {

        let items = objects as! [NSManagedObject]
        
        return items.map {
            
            return $0.value(forKey: "guid") as Any
        }
    }
}
