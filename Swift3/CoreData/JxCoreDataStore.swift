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

class JxCoreDataStore:NSObject {
    
    let name:String
    let groupIdentifier:String
    let directory:URL?
    
    init(withStoreName storename: String, andGroupIdentifier identifier:String="", inDirectory directory:URL?=nil){
        
        self.name = storename
        self.groupIdentifier = identifier
        self.directory = directory
        
        super.init()
        
        if #available(iOS 10.0, *){
            
        }else{
            self.setupNotifications()
        }
    }

    func managedObjectID(forURIRepresentation uri: URL) -> NSManagedObjectID?{
        if #available(iOS 10.0, *) {
            return self.persistentContainer.persistentStoreCoordinator.managedObjectID(forURIRepresentation: uri)
        }
        
        return self.persistentStoreCoordinator.managedObjectID(forURIRepresentation: uri)
    }
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        
        let modelURL = Bundle.main.url(forResource: self.name, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
        
    }()
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.storeURL()
        do {
            // If your looking for any kind of migration then here is the time to pass it to the options
            let options = [ NSMigratePersistentStoresAutomaticallyOption : true,
                            NSInferMappingModelAutomaticallyOption : true ]
            
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch let  error as NSError {
            print("Ops there was an error \(error.localizedDescription)")
            abort()
        }
        return coordinator
    }()
    func setupNotifications(){
        NotificationCenter.default.addObserver(self, selector:#selector(self.contextDidSave), name:NSNotification.Name.NSManagedObjectContextDidSave, object:nil)
    }
    @objc func contextDidSave(_ notification:Notification){
        self.mainManagedObjectContext.perform {
            self.mainManagedObjectContext.mergeChanges(fromContextDidSave: notification)
        }
        
    }
    func storeURL() -> URL?{

        if !self.groupIdentifier.isEqual("") && self.directory == nil{
            
            if var url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: self.groupIdentifier){
                
                #if os(tvOS)
                    url = url.appendingPathComponent("Library/Caches")
                #endif
                
                url.appendPathComponent(String(format: "%@.sqlite", self.name))
                
                return url
            }
            
        }else if self.groupIdentifier.isEqual("") && self.directory != nil{
            
            if var url = self.directory{
                
                url.appendPathComponent(String(format: "%@.sqlite", self.name))
                
                return url
            }
        }

        return nil
    }
    lazy var mainManagedObjectContext: NSManagedObjectContext = {
        if #available(iOS 10.0, *){
            self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
            return self.persistentContainer.viewContext
        }
        var context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    func newPrivateContext() -> NSManagedObjectContext {
        if #available(iOS 10.0, *) {
            let context = self.persistentContainer.newBackgroundContext()
            context.automaticallyMergesChangesFromParent = true
            return context
        }
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    func performForegroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.mainManagedObjectContext.perform {
            block(self.mainManagedObjectContext)
        }
    }
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        if #available(iOS 10.0, *){
            self.persistentContainer.performBackgroundTask(block)
        }else{
            
            let pContext = self.newPrivateContext()
            pContext.perform {
                block(pContext)
            }
        }
    }
    
    func deleteDatabasse(){
        if let url = self.storeURL(){
            do {
                try FileManager.default.removeItem(atPath: url.path)
            } catch let error as NSError {
                print(error)
            }
        }
    }

    func getURIPrepresentation(forID idString: String, andEntityName entityName: String) -> URL?{
        let urlString = self.getStringPrepresentation(forID: idString, andEntityName:entityName)
        
        return URL(string: urlString)
    }
    func getURIPrepresentation(forID idString: String, andEntityName entityName: String, andStoreUUID uuid: String) -> URL?{
        let urlString = self.getStringPrepresentation(forID: idString, andEntityName:entityName, andStoreUUID: uuid)
        
        return URL(string: urlString)
    }
    func getStoreUUID() -> String{
        let storeCoordinator = self.persistentStoreCoordinator
        
        let metaData = storeCoordinator.metadata(for: storeCoordinator.persistentStores.first!)
        
        return metaData[NSStoreUUIDKey] as? String ?? "UNKNOWN_STORE_UUID"
    }
    func getStringPrepresentation(forID idString: String, andEntityName entityName: String) -> String{
        return String(format: "x-coredata://%@/%@/%@", self.getStoreUUID() as CVarArg, entityName, idString)
    }
    func getStringPrepresentation(forID idString: String, andEntityName entityName: String, andStoreUUID uuid: String) -> String{
        return String(format: "x-coredata://%@/%@/%@", uuid, entityName, idString)
    }
    
    // MARK: iOS 10 Funktionen
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.name)
        
        if let url = self.storeURL(){
            
            var description = NSPersistentStoreDescription(url: url)
            description.shouldInferMappingModelAutomatically = true
            description.shouldMigrateStoreAutomatically = true
            
            container.persistentStoreDescriptions = [description]
            
            container.loadPersistentStores(completionHandler: { (description, error) in
                if let error = error {
                    print("CoreData error", error, error._userInfo as Any)
                    
                    let defaults = UserDefaults.standard
                    defaults.set(error.localizedDescription, forKey: "CoreDataError")
                    defaults.set(nil, forKey: "firstStart")
                    defaults.synchronize()
                    
                    self.deleteDatabasse()
                    
                    abort()
                }
            })
            return container
        }
        
        return self.persistentContainer
    }()
}
