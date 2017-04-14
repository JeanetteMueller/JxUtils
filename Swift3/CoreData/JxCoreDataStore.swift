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
    }

    var errorHandler: (Error) -> Void = {_ in }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.name)
        
        if let url = self.storeURL(){
                container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: url)]
        }
        
        
        container.loadPersistentStores(completionHandler: { [weak self](storeDescription, error) in
            if let error = error {
                print("CoreData error", error, error._userInfo as Any)
                self?.errorHandler(error)
            }
        })
        return container
    }()
    
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
