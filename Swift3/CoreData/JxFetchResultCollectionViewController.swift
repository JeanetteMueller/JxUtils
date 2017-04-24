//
//  JxFetchResultTableViewController.swift
//  projectPhoenix
//
//  Created by Jeanette Müller on 18.10.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import UIKit
import CoreData

class JxFetchResultCollectionViewController: PCCollectionViewController, NSFetchedResultsControllerDelegate{
    
    var cellIdentifier: String = "Cell"
    
    private var _fetchedResultsController:NSFetchedResultsController<NSManagedObject>!
    var managedObjectContext:NSManagedObjectContext?
    
    var entityName:String?
    var sectionKeyPath:String?
    var predicates = [NSPredicate]()
    
    var searchPredicate: NSPredicate?
    var sortDescriptors = [NSSortDescriptor]()
    var fetchLimit:Int = 0
    
    var firstTimeOpened = true
    var dynamicUpdate = true
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: Init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        basicFetchProperties()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
        basicFetchProperties()
    }
    
    func basicFetchProperties() {
        print("WARNING: You have to override this method to set cellIdentifier, managedObjectContext, entityName, predicates and sortDescriptors")
    }
    
    // MARK: View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true
        
        if self.refetchData(){
            self.collectionView?.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _fetchedResultsController.delegate = self
        
        if firstTimeOpened == false{
            if self.refetchData() {
                self.collectionView?.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        firstTimeOpened = false
        self.collectionView?.scrollsToTop = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.collectionView?.scrollsToTop = false
        
        _fetchedResultsController.delegate = nil
        
        super.viewWillDisappear(animated)
    }
    
    // MARK: UICollectionView DataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        var count = 1
        
        if let sections = self.fetchedResultsController.sections{
            count = sections.count
        }
        return count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        
        if let sections = self.fetchedResultsController.sections{
            
            if sections.count > section {
                
                let sectionInfo = sections[section]
                
                count = sectionInfo.numberOfObjects
            }
        }
        return count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath)
        
        self.configureCell(cell, atIndexPath: indexPath)
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.startCell(cell, atIndexPath: indexPath)
    }
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.unloadCell(cell, atIndexPath: indexPath)
    }
    

    // MARK: Use Cells
    
    func configureCell(_ cell: UICollectionViewCell, atIndexPath indexPath: IndexPath){
        
        print("time to override this method ->", "func configureCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)")
    }
    
    func startCell(_ cell: UICollectionViewCell, atIndexPath indexPath: IndexPath){
        
        print("time to override this method ->", "func startCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)")
    }
    
    func unloadCell(_ cell: UICollectionViewCell, atIndexPath indexPath: IndexPath){
        
        print("time to override this method ->", "func unloadCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)\n Dont forget to NotificationCenter.default.removeObserver(cell) ")
        
        NotificationCenter.default.removeObserver(cell)
    }
    
    
    // MARK: Fetch Result Controller
    
    var fetchedResultsController: NSFetchedResultsController<NSManagedObject> {
        if let fetchedResultsController = self._fetchedResultsController{
            
            return fetchedResultsController
        }
        
        let fetchRequest:NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: self.entityName!)
        
        if self.predicates.count > 0 {
            fetchRequest.predicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: self.predicates)
        }
        if let search = self.searchPredicate{
            
            var filteredPredicates = self.predicates
            filteredPredicates.append(search)
            
            fetchRequest.predicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: filteredPredicates)
        }
        if self.sortDescriptors.count > 0 {
            fetchRequest.sortDescriptors = sortDescriptors;
        }
        
        fetchRequest.returnsObjectsAsFaults = false
        if self.fetchLimit > 0 {
            fetchRequest.fetchLimit = self.fetchLimit
        }
        
        fetchRequest.fetchBatchSize = 10
        
        if let context = self.managedObjectContext{
            let aFetchedResultsController:NSFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                                                  managedObjectContext: context,
                                                                                                  sectionNameKeyPath: self.sectionKeyPath,
                                                                                                  cacheName: nil)
            
            
            aFetchedResultsController.delegate = self
            _fetchedResultsController = aFetchedResultsController
        }
        return _fetchedResultsController!
    }
    
    func refetchData() -> Bool{
        
        _fetchedResultsController = nil
        
        do {
            try self.fetchedResultsController.performFetch()
            return true
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        return false
    }
    
    func object(at indexPath: IndexPath) -> NSManagedObject?{
        if let sections = self.fetchedResultsController.sections{
        
            if sections.count > indexPath.section {
                
                let sectionInfo = sections[indexPath.section] as NSFetchedResultsSectionInfo
                    
                if sectionInfo.numberOfObjects > indexPath.row {
                    return self.fetchedResultsController.object(at: indexPath)
                }
                
            }
        }
        return nil
    }
    func indexPath(forObject object:NSManagedObject) -> IndexPath?{
        
        return self.fetchedResultsController.indexPath(forObject: object)
    }
    func allObjects() -> [NSManagedObject] {
        if let all = self.fetchedResultsController.fetchedObjects{
            return all
        }
        return [NSManagedObject]()
    }
    
    // MARK: Fetch Result Controller Delegate
    
    var blockOperations: [BlockOperation] = []
    
    internal func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        if (self.navigationController == nil || (self.navigationController != nil && (self.navigationController?.viewControllers.last?.isEqual(self))! ))  && self.dynamicUpdate == true{
            
            blockOperations.removeAll(keepingCapacity: false)
        }
    }
    
    internal func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        
        return nil
    }
    
    internal func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        if (self.navigationController == nil || (self.navigationController != nil && (self.navigationController?.viewControllers.last?.isEqual(self))! ))  && self.dynamicUpdate == true{
            
            if type == NSFetchedResultsChangeType.insert {
                print("Insert Section: \(sectionIndex)")
                
                blockOperations.append(
                    BlockOperation(block: { [weak self] in
                        if let this = self {
                            this.collectionView!.insertSections(IndexSet.init(integer: sectionIndex))
                        }
                    })
                )
            }
            else if type == NSFetchedResultsChangeType.update {
                print("Update Section: \(sectionIndex)")
                blockOperations.append(
                    BlockOperation(block: { [weak self] in
                        if let this = self {
                            this.collectionView!.reloadSections(IndexSet.init(integer: sectionIndex))
                        }
                    })
                )
            }
            else if type == NSFetchedResultsChangeType.delete {
                print("Delete Section: \(sectionIndex)")
                
                if let numberOfSections = collectionView?.numberOfSections, numberOfSections > 1{
                    blockOperations.append(
                        BlockOperation(block: { [weak self] in
                            if let this = self {
                                this.collectionView!.deleteSections(IndexSet.init(integer: sectionIndex))
                            }
                        })
                    )
                }
            }
        }
    }
    
    internal func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if (self.navigationController == nil || (self.navigationController != nil && (self.navigationController?.viewControllers.last?.isEqual(self))! ))  && self.dynamicUpdate == true{
            
            if type == NSFetchedResultsChangeType.insert {
                print("Insert Object: ", newIndexPath as Any)
                
                blockOperations.append(
                    BlockOperation(block: { [weak self] in
                        if let this = self {
                            this.collectionView!.insertItems(at: [newIndexPath!])
                        }
                    })
                )
            }
            else if type == NSFetchedResultsChangeType.update {
                print("Update Object: ", newIndexPath as Any)
                blockOperations.append(
                    BlockOperation(block: { [weak self] in
                        if let this = self {
                            this.collectionView!.reloadItems(at: [indexPath!])
                        }
                    })
                )
            }
            else if type == NSFetchedResultsChangeType.move {
                print("Move Object: ", newIndexPath as Any)
                
                blockOperations.append(
                    BlockOperation(block: { [weak self] in
                        if let this = self {
                            this.collectionView!.moveItem(at: indexPath!, to: newIndexPath!)
                        }
                    })
                )
            }
            else if type == NSFetchedResultsChangeType.delete {
                print("Delete Object: ", newIndexPath as Any)
                
                blockOperations.append(
                    BlockOperation(block: { [weak self] in
                        if let this = self {
                            this.collectionView!.deleteItems(at: [indexPath!])
                        }
                    })
                )
            }
        }
    }
    
    internal func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if (self.navigationController == nil || (self.navigationController != nil && (self.navigationController?.viewControllers.last?.isEqual(self))! )  ) && self.dynamicUpdate == true{
            
            collectionView!.performBatchUpdates({ () -> Void in
                for operation: BlockOperation in self.blockOperations {
                    operation.start()
                }
            }, completion: { (finished) -> Void in
                self.blockOperations.removeAll(keepingCapacity: false)
            })
            
        }else{
            self.collectionView?.reloadData()
            self.dynamicUpdate = true
        }
    }
    
    deinit {
        // Cancel all block operations when VC deallocates
        for operation: BlockOperation in blockOperations {
            operation.cancel()
        }
        
        blockOperations.removeAll(keepingCapacity: false)
    }
}
