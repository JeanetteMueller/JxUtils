//
//  JxFetchResultTableViewController.swift
//  projectPhoenix
//
//  Created by Jeanette Müller on 18.10.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import UIKit
import CoreData

class JxFetchResultTableViewController: PCTableViewController, NSFetchedResultsControllerDelegate{
    
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
            self.tableView?.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _fetchedResultsController.delegate = self
        
        if firstTimeOpened == false{
            if self.refetchData() {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        firstTimeOpened = false
        #if os(OSX) || os(iOS)
        self.tableView?.scrollsToTop = true
        #endif
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        #if os(OSX) || os(iOS)
        self.tableView?.scrollsToTop = false
        #endif
        
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        #if os(OSX) || os(iOS)
        self.tableView?.scrollsToTop = false
        #endif
        
        _fetchedResultsController.delegate = nil
        
        super.viewDidDisappear(animated)
    }
    
    // MARK: UITableView DataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = self.fetchedResultsController.sections{
            let count = sections.count
            
            return count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = self.fetchedResultsController.sections
        var count = 0;
        
        if (sections?.count)! > section {
            
            let sectionInfo = sections?[section]
            
            count = (sectionInfo?.numberOfObjects)!
        }
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        
        self.configureCell(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    // MARK: UITableView Delegate
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.startCell(cell, atIndexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.unloadCell(cell, atIndexPath: indexPath)
    }
    
    // MARK: Use Cells
    
    func configureCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath){
        
        print("time to override this method ->", "func configureCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)")
        
        if let object = self.object(at: indexPath) {
        
            cell.textLabel?.text = object.objectID.description
        }
    }
    
    func startCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath){
        
        print("time to override this method ->", "func startCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)")
    }
    func updateCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath){
        print("time to override this method ->", "func updateCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)")
        
        
    }
    func unloadCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath){
        
        print("time to override this method ->", "func unloadCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)\n Dont forget to NotificationCenter.default.removeObserver(cell) ")
        
        NotificationCenter.default.removeObserver(cell)
    }
    
    // MARK: Fetch Result Controller
    
    var fetchedResultsController: NSFetchedResultsController<NSManagedObject> {
        if let fetchedResultsController = self._fetchedResultsController{
            
            return fetchedResultsController
        }
        
        let fetchRequest:NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: self.entityName!)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 10
        
        if self.sortDescriptors.count > 0 {
            fetchRequest.sortDescriptors = sortDescriptors;
        }
        
        if let context = self.managedObjectContext{
            let aFetchedResultsController:NSFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                                                  managedObjectContext: context,
                                                                                                  sectionNameKeyPath: self.sectionKeyPath,
                                                                                                  cacheName: nil )
            
            aFetchedResultsController.delegate = self
            _fetchedResultsController = aFetchedResultsController
        }
        return _fetchedResultsController!
    }
    
    func refetchData() -> Bool{
        
        let resultController = self.fetchedResultsController
        
        if self.predicates.count > 0 {
            resultController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: self.predicates)
        }else{
            resultController.fetchRequest.predicate = nil
        }
        if let search = self.searchPredicate{
            
            var filteredPredicates = self.predicates
            filteredPredicates.append(search)
            
            resultController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: filteredPredicates)
        }
        if self.sortDescriptors.count > 0 {
            resultController.fetchRequest.sortDescriptors = sortDescriptors;
        }else{
            resultController.fetchRequest.sortDescriptors = nil
        }
        
        resultController.fetchRequest.fetchLimit = 0
        if self.fetchLimit > 0 {
            resultController.fetchRequest.fetchLimit = self.fetchLimit
        }

        do {
            try resultController.performFetch()
            return true
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        return false
    }
    
    func object(at indexPath: IndexPath) -> NSManagedObject?{
        
        if let sections = self.fetchedResultsController.sections, sections.count > indexPath.section {
            
            let sectionInfo = sections[indexPath.section]
                
            if sectionInfo.numberOfObjects > indexPath.row {
                return self.fetchedResultsController.object(at: indexPath)
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
    func allObjects(for section:Int) -> [NSManagedObject] {
        
        if let sectionObjects = self.fetchedResultsController.sections?[section].objects{
            return sectionObjects as! [NSManagedObject]
        }
        return [NSManagedObject]()
    }
    
    // MARK: Fetch Result Controller Delegate
    
    internal func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        if (self.navigationController == nil || (self.navigationController != nil && (self.navigationController?.viewControllers.last?.isEqual(self))! )) && self.dynamicUpdate == true{
            self.tableView?.beginUpdates()
        }
    }
    
    internal func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        
        return nil
    }
    
    internal func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        if (self.navigationController == nil || (self.navigationController != nil && (self.navigationController?.viewControllers.last?.isEqual(self))! )) && self.dynamicUpdate == true{
            
            switch(type) {
            case .insert:
                self.tableView?.insertSections(IndexSet(integer: sectionIndex), with: .middle)
                break
                
            case .delete:
                self.tableView?.deleteSections(IndexSet(integer: sectionIndex), with: .middle)
                break
            default:
                
                break;
            }
        }
    }
    
    internal func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if (self.navigationController == nil || (self.navigationController != nil && (self.navigationController?.viewControllers.last?.isEqual(self))!))  && self.dynamicUpdate == true{
            
            switch(type) {
            case .insert:
                if let newIndexPath = newIndexPath {
                    print("insert \(newIndexPath)")
                    self.tableView?.insertRows(at: [newIndexPath], with: .middle)
                }
                break;
                
            case .delete:
                if let indexPath = indexPath {
                    print("delete \(indexPath)")
                    let cell = self.tableView?.cellForRow(at: indexPath)
                    
                    NotificationCenter.default.removeObserver(cell as Any)
                    
                    self.tableView?.deleteRows(at: [indexPath], with: .middle)
                }
                break;
                
            case .update:
                if let indexPath = indexPath {
                    print("update \(indexPath)")
                    if let cell = self.tableView?.cellForRow(at: (indexPath)) {
                        
//                        NotificationCenter.default.removeObserver(cell)
//                        
//                        self.configureCell(cell, atIndexPath: indexPath)
//                        
//                        self.startCell(cell, atIndexPath:indexPath)
                        
                        self.updateCell(cell, atIndexPath:indexPath)
                    }
                }
                break;
                
            case .move:
                if let deleteIndexPath = indexPath, let insertIndexPath = newIndexPath {
                    self.tableView?.moveRow(at: deleteIndexPath, to: insertIndexPath)
                }
//                if let deleteIndexPath = indexPath {
//                    self.tableView?.deleteRows(at: [deleteIndexPath], with: .none)
//                }
//                
//                if let insertIndexPath = newIndexPath {
//                    
//                    self.tableView?.insertRows(at: [insertIndexPath], with: .none)
//                }
                break;
            }
        }
    }
    
    internal func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if (self.navigationController == nil || (self.navigationController != nil && (self.navigationController?.viewControllers.last?.isEqual(self))!)) && self.dynamicUpdate == true{
                
                self.tableView?.endUpdates()
            
        }else{
            self.tableView?.reloadData()
            
            self.dynamicUpdate = true
        }
    }
    

}
