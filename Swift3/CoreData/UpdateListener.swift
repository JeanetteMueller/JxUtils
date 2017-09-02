//
//  UpdateListener.swift
//  CoreDataUpdateListener
//
//  Created by Rugen Heidbuchel on 03/08/15.
//  Updated by Rugen Heidbuchel on 03/10/15.
//  Copyright © 2015 Rugen Heidbuchel. All rights reserved.
//

import CoreData

/**
 An abstract class that listens to Core Data's update notifications to set the insertDate and updateDate properties.
 */
class UpdateListener {
    
    
    // MARK: Settings
    
    /// Indicates whether UpdateListener should print updates to the console.
    var loggingEnabled = true
    
    
    
    // MARK: Property Names
    var insertDateProperty = "insertDate"
    var updateDateProperty = "updateDate"
    
    
    
    // MARK: Singleton
    
    /// A shared UpdateListener
    static let sharedInstance = UpdateListener()
    
    /// Sets up the shared instance of UpdateListener.
    static func setupSharedInstance() {
        _ = UpdateListener.sharedInstance
    }
    
    
    
    // MARK: Init
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(managedObjectContextWillSave), name: Notification.Name.NSManagedObjectContextWillSave, object: nil)
    }
    
    
    
    // MARK: Notifications
    
    /**
     This gets called when a managed object context will save. It updates all insertDate and updateDate properties.
     */
    @objc func managedObjectContextWillSave(notification: NSNotification) {
        // Get the managed object context from the notification
        let managedObjectContext = notification.object as! NSManagedObjectContext
        
        // Loop through the set of inserted and updated managed objects
        for managedObject in managedObjectContext.updatedObjects.union(managedObjectContext.insertedObjects) {
            
            // If it has an insertDate property, update it
            if managedObject.isInserted && managedObject.entity.attributesByName[insertDateProperty] != nil {
                managedObject.setValue(NSDate(), forKey: insertDateProperty)
                
                if self.loggingEnabled {
                    print("Updated \(insertDateProperty) for entity of name: \(managedObject.entity.name!)")
                }
            }
            
            // If it has an updateDate property, update it
            if managedObject.isUpdated && managedObject.entity.attributesByName[updateDateProperty] != nil {
                managedObject.setValue(NSDate(), forKey: updateDateProperty)
                
                if self.loggingEnabled {
                    print("Updated \(updateDateProperty) for entity of name: \(managedObject.entity.name!)")
                }
            }
        }
    }
}
