//
//  JxCoreDataStore.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 20.10.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension Notification.Name {
    static let JxCoreDataStoreDidChange = Notification.Name("JxCoreDataStoreDidChange")
}

class JxCoreDataStore {
    
    let name:String
    
    private var _mainManagedObjectContext:NSManagedObjectContext!
    private var _persistentStoreCoordinator: NSPersistentStoreCoordinator!
    private var _managedObjectModel: NSManagedObjectModel!
    
    var mainManagedObjectContext: NSManagedObjectContext {
        if let mainManagedObjectContext = self._mainManagedObjectContext{
            
            return mainManagedObjectContext
        }
        
        if Thread.current.isMainThread == false{
            
            DispatchQueue.mainSyncSafe(execute: {
                self._mainManagedObjectContext = self.mainManagedObjectContext
            })
            
            return _mainManagedObjectContext;
        }
        
        _mainManagedObjectContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        _mainManagedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator()
        _mainManagedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return _mainManagedObjectContext
    }
    
    var newPrivateContext: NSManagedObjectContext {
        let context = NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType)
        
        context.persistentStoreCoordinator = self.persistentStoreCoordinator()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return context;
    }
    
    init(withStoreName storename: String){
        
        self.name = storename
    }
    
    func setupNotification() {
        
        NotificationCenter.default.removeObserver(self)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.managedObjectContextDidSaveNotification),
                                               name: .NSManagedObjectContextDidSave,
                                               object: nil)
    }
    
    @objc func managedObjectContextDidSaveNotification(notification: NSNotification){
        
        let moc = self.mainManagedObjectContext

        if let backgroundMoc = notification.object as! NSManagedObjectContext?{
            
            if (backgroundMoc != moc &&
                moc.persistentStoreCoordinator != nil &&
                backgroundMoc.persistentStoreCoordinator == moc.persistentStoreCoordinator &&
                moc.persistentStoreCoordinator == self.persistentStoreCoordinator()
                ) {
                
                moc.mergeChanges(fromContextDidSave: notification as Notification)
                
                NotificationCenter.default.post(name: .JxCoreDataStoreDidChange,
                                                object: notification.object,
                                                userInfo: notification.userInfo)
                
            }
        }
    }
    
    func applicationDocumentsDirectory() -> NSURL{
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last! as NSURL
    }
    
    func getDBFileName() -> String{
        return String.init(format: "%@.sqlite", self.name)
    }
    
    func managedObjectModel() -> NSManagedObjectModel{
        if let managedObjectModel = self._managedObjectModel {
            return managedObjectModel
        }
        
        let modelURL = Bundle.main.url(forResource: self.name, withExtension: "momd")
        _managedObjectModel = NSManagedObjectModel.init(contentsOf: modelURL!)
        
        return _managedObjectModel;
    }
    
    func getSQLiteOptions() -> [AnyHashable:Any]{
        return [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ]
    }
    
    func persistentStoreCoordinator() -> NSPersistentStoreCoordinator{
        if let persistentStoreCoordinator = self._persistentStoreCoordinator {
            return persistentStoreCoordinator
        }
        
        if Thread.current.isMainThread == false{
            
            DispatchQueue.mainSyncSafe(execute: {
                self._persistentStoreCoordinator = self.persistentStoreCoordinator()
            })
            
            return _persistentStoreCoordinator;
        }
        self.setupNotification()
        
        _persistentStoreCoordinator = NSPersistentStoreCoordinator.init(managedObjectModel: managedObjectModel())
        
        let storeURL = self.applicationDocumentsDirectory().appendingPathComponent(getDBFileName())!
        
        try! _persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                            configurationName: nil,
                                                            at: storeURL,
                                                            options: getSQLiteOptions())
        
        return _persistentStoreCoordinator;
    }
    
    func getURIPrepresentation(forID idString: String, andEntityName entityName: String) -> NSURL?{
        let urlString = self.getStringPrepresentation(forID: idString, andEntityName:entityName)
        
        return NSURL(string: urlString)
    }
    
    func getStringPrepresentation(forID idString: String, andEntityName entityName: String) -> String{
        let storeCoordinator = persistentStoreCoordinator()
        
        let metaData = storeCoordinator.metadata(for: storeCoordinator.persistentStores.first!)
        
        return String(format: "x-coredata://%@/%@/%@", metaData[NSStoreUUIDKey] as! CVarArg, entityName, idString)
    }
}
