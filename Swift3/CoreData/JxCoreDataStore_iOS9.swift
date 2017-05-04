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

class JxCoreDataStore:NSObject {
    
    let name:String
    let groupIdentifier:String
    let directory:URL?
    
    init(withStoreName storename: String, andGroupIdentifier identifier:String="", inDirectory directory:URL?=nil){
        
        self.name = storename
        self.groupIdentifier = identifier
        self.directory = directory
        
        super.init()
        self.setupNotifications()
    }

    func managedObjectID(forURIRepresentation uri: URL) -> NSManagedObjectID?{
        
        return self.persistentStoreCoordinator.managedObjectID(forURIRepresentation: uri)
    }
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // 1
        let modelURL = Bundle.main.url(forResource: self.name, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.storeURL()
        do {
            // If your looking for any kind of migration then here is the time to pass it to the options
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch let  error as NSError {
            print("Ops there was an error \(error.localizedDescription)")
            abort()
        }
        return coordinator
    }()
    func setupNotifications(){
        NotificationCenter.default.addObserver(self, selector:#selector(self.contextDidSave), name:NSNotification.Name.NSManagedObjectContextDidSave, object:nil)
    }
    func contextDidSave(_ notification:Notification){
        
        self.mainManagedObjectContext.mergeChanges(fromContextDidSave: notification)
    }
    func storeURL() -> URL?{
        if !self.groupIdentifier.isEqual("") && self.directory == nil{
            
            if var url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: self.groupIdentifier){
                
                url.appendPathComponent(String.init(format: "%@.sqlite", self.name))
                
                return url
            }
            
        }else if self.groupIdentifier.isEqual("") && self.directory != nil{
            
            if var url = self.directory{
                
                url.appendPathComponent(String.init(format: "%@.sqlite", self.name))
                
                return url
            }
        }
        return nil
    }
    lazy var mainManagedObjectContext: NSManagedObjectContext = {
        
        var context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    lazy var newPrivateContext: NSManagedObjectContext = {
        var context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    func performForegroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.mainManagedObjectContext.perform {
            block(self.mainManagedObjectContext)
        }
    }
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        
        DispatchQueue.global(qos: .background).async {
            block(self.newPrivateContext)
            
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
