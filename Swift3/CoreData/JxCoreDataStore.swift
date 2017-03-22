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
    let groupIdentifier:String
    let directory:URL?
    
    init(withStoreName storename: String){
        
        self.name = storename
        self.groupIdentifier = ""
        self.directory = nil
    }
    init(withStoreName storename: String, andGroupIdentifier identifier:String){
        
        self.name = storename
        self.groupIdentifier = identifier
        self.directory = nil
    }
    init(withStoreName storename: String, inDirectory directory:URL){
        
        self.name = storename
        self.groupIdentifier = ""
        self.directory = directory
    }
    
    var errorHandler: (Error) -> Void = {_ in }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.name)
        
        if !self.groupIdentifier.isEqual("") && self.directory == nil{
            
            if var url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: self.groupIdentifier){
                
                url.appendPathComponent(String.init(format: "%@.sqlite", self.name))
                
                container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: url)]
            }
            
        }else if self.groupIdentifier.isEqual("") && self.directory != nil{
            
            if var url = self.directory{
                
                url.appendPathComponent(String.init(format: "%@.sqlite", self.name))
                
                container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: url)]
            }
        }
        
        container.loadPersistentStores(completionHandler: { [weak self](storeDescription, error) in
            if let error = error {
                print("CoreData error", error, error._userInfo as Any)
                self?.errorHandler(error)
            }
        })
        return container
    }()
    
    lazy var mainManagedObjectContext: NSManagedObjectContext = {
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        return self.persistentContainer.viewContext
    }()
    lazy var newPrivateContext: NSManagedObjectContext = {
        let context = self.persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    func performForegroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.mainManagedObjectContext.perform {
            block(self.mainManagedObjectContext)
        }
    }
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.persistentContainer.performBackgroundTask(block)
    }
    
    func deleteDatabasse(){
        
        
        if !self.groupIdentifier.isEqual("") && self.directory == nil{
            
            if var url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: self.groupIdentifier){
                
                url.appendPathComponent(String.init(format: "%@.sqlite", self.name))
                
                do {
                    try FileManager.default.removeItem(atPath: url.path)
                } catch let error as NSError {
                    print(error)
                }
                
            }
            
        }else if self.groupIdentifier.isEqual("") && self.directory != nil{
            
            if var url = self.directory{
                
                url.appendPathComponent(String.init(format: "%@.sqlite", self.name))
                
                do {
                    try FileManager.default.removeItem(atPath: url.path)
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        
    }
    
    
//    private var _mainManagedObjectContext:NSManagedObjectContext!
//    private var _persistentStoreCoordinator: NSPersistentStoreCoordinator!
//    private var _managedObjectModel: NSManagedObjectModel!
    
    /*
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
 */
    /*
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.name, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent(self.getDBFileName())
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: url,
                                               options: [NSMigratePersistentStoresAutomaticallyOption: true,
                                                         NSInferMappingModelAutomaticallyOption: true])
        } catch {
            // Report any error we got.
            NSLog("CoreData error \(error), \(error._userInfo)")
            self.errorHandler(error)
        }
        return coordinator
    }()
    
    var errorHandler: (Error) -> Void = {_ in }
    
    lazy var backgroundManagedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateManagedObjectContext.persistentStoreCoordinator = coordinator
        return privateManagedObjectContext
    }()
    

    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainManagedObjectContext.persistentStoreCoordinator = coordinator
        return mainManagedObjectContext
    }()
    
 
    
    func setupNotification() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.mainContextChanged(notification:)),
                                               name: .NSManagedObjectContextDidSave,
                                               object: self.managedObjectContext)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.bgContextChanged(notification:)),
                                               name: .NSManagedObjectContextDidSave,
                                               object: self.backgroundManagedObjectContext)
    }
    
    @objc func mainContextChanged(notification: NSNotification) {
        backgroundManagedObjectContext.perform { [unowned self] in
            self.backgroundManagedObjectContext.mergeChanges(fromContextDidSave: notification as Notification)
        }
    }
    
    @objc func bgContextChanged(notification: NSNotification) {
        managedObjectContext.perform{ [unowned self] in
            self.managedObjectContext.mergeChanges(fromContextDidSave: notification as Notification)
        }
    }
    
    
    func getDBFileName() -> String{
        return String.init(format: "%@.sqlite", self.name)
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
     */
    func getURIPrepresentation(forID idString: String, andEntityName entityName: String) -> URL?{
        let urlString = self.getStringPrepresentation(forID: idString, andEntityName:entityName)
        
        return URL(string: urlString)
    }
    func getURIPrepresentation(forID idString: String, andEntityName entityName: String, andStoreUUID uuid: String) -> URL?{
        let urlString = self.getStringPrepresentation(forID: idString, andEntityName:entityName, andStoreUUID: uuid)
        
        return URL(string: urlString)
    }
    func getStoreUUID() -> String{
        let storeCoordinator = self.persistentContainer.persistentStoreCoordinator;
        
        let metaData = storeCoordinator.metadata(for: storeCoordinator.persistentStores.first!)
        
        return metaData[NSStoreUUIDKey] as! String
    }
    func getStringPrepresentation(forID idString: String, andEntityName entityName: String) -> String{
        
        //let storeCoordinator = persistentStoreCoordinator()
        
        return String(format: "x-coredata://%@/%@/%@", self.getStoreUUID() as CVarArg, entityName, idString)
    }
    func getStringPrepresentation(forID idString: String, andEntityName entityName: String, andStoreUUID uuid: String) -> String{
        
        return String(format: "x-coredata://%@/%@/%@", uuid, entityName, idString)
    }
}
