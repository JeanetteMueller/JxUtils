//
//  JxFetchResultTableViewController.swift
//  projectPhoenix
//
//  Created by Jeanette Müller on 18.10.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import UIKit
import CoreData

class JxFetchResultTableViewController: UITableViewController, NSFetchedResultsControllerDelegate{
    
    var cellIdentifier: String = "Cell"
    
    private var _fetchedResultsController:NSFetchedResultsController<NSManagedObject>!
    var managedObjectContext:NSManagedObjectContext?
    
    var entityName:String?
    var sectionKeyPath:String?
    var predicates = [NSPredicate]()
    var sortDescriptors: [NSSortDescriptor]?
    var fetchLimit:Int = 0
    
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
        
        if self.refetchData(){
            self.tableView?.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView?.scrollsToTop = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.tableView?.scrollsToTop = false
        
        super.viewWillDisappear(animated)
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
        
        let object = self.object(at: indexPath)
        
        cell.textLabel?.text = object.objectID.description
    }
    
    func startCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath){
        
        print("time to override this method ->", "func startCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)")
    }
    
    func unloadCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath){
        
        print("time to override this method ->", "func unloadCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)\n Dont forget to NotificationCenter.default.removeObserver(cell) ")
        
        NotificationCenter.default.removeObserver(cell)
    }
    
    // MARK: Fetch Result Controller
    
    private var fetchedResultsController: NSFetchedResultsController<NSManagedObject> {
        if let fetchedResultsController = self._fetchedResultsController{
            
            return fetchedResultsController
        }
        
        let fetchRequest:NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: self.entityName!)
        
        if self.predicates.count > 0 {
            fetchRequest.predicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: self.predicates)
        }
        if let sortDescriptors = self.sortDescriptors {
            fetchRequest.sortDescriptors = sortDescriptors;
        }
        
        fetchRequest.returnsObjectsAsFaults = false
        if self.fetchLimit > 0 {
            fetchRequest.fetchLimit = self.fetchLimit
        }
        
        fetchRequest.fetchBatchSize = 10
        
        let aFetchedResultsController:NSFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                                              managedObjectContext: self.managedObjectContext!,
                                                                                              sectionNameKeyPath: self.sectionKeyPath,
                                                                                              cacheName: nil)
        
        
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        return _fetchedResultsController!
    }
    
    func resetFetchResultController(){
        _fetchedResultsController = nil
    }
    
    func refetchData() -> Bool{
        
        do {
            try self.fetchedResultsController.performFetch()
            return true
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        return false
    }
    
    func object(at indexPath: IndexPath) -> NSManagedObject{
        return self.fetchedResultsController.object(at: indexPath)
    }
    
    // MARK: Fetch Result Controller Delegate
    
    internal func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if (self.navigationController?.viewControllers.last?.isEqual(self))!{
            
            self.tableView?.beginUpdates()
        }
    }
    
    internal func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        
        return nil
    }
    
    internal func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        if (self.navigationController?.viewControllers.last?.isEqual(self))!{
            
            switch(type) {
            case .insert:
                self.tableView?.insertSections(IndexSet.init(integer: sectionIndex), with: .middle)
                break;
                
            case .delete:
                self.tableView?.deleteSections(IndexSet.init(integer: sectionIndex), with: .middle)
                break;
            default:
                
                break;
            }
        }
    }
    
    internal func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if (self.navigationController?.viewControllers.last?.isEqual(self))!{
            
            switch(type) {
            case .insert:
                if let newIndexPath = newIndexPath {
                    self.tableView?.insertRows(at: [newIndexPath], with: .middle)
                    
                    
                    let headerView = self.tableView?.headerView(forSection: newIndexPath.section)
                    //if headerView != nil && [headerView respondsToSelector:@selector(update)]) {
                    //    [headerView performSelector:@selector(update)];
                    //}
                    
                    headerView?.setNeedsDisplay()
                    headerView?.setNeedsLayout()
                }
                break;
                
            case .delete:
                if let indexPath = indexPath {
                    let cell = self.tableView?.cellForRow(at: indexPath)
                    
                    NotificationCenter.default.removeObserver(cell as Any)
                    
                    self.tableView?.deleteRows(at: [indexPath], with: .middle)
                    
                    let headerView = self.tableView?.headerView(forSection: (newIndexPath?.section)!)
                    
                    //if ([headerView respondsToSelector:@selector(update)]) {
                    //    [headerView performSelector:@selector(update)];
                    //}
                    
                    headerView?.setNeedsDisplay()
                    headerView?.setNeedsLayout()
                }
                break;
                
            case .update:
                if let indexPath = indexPath {
                    if let cell = self.tableView?.cellForRow(at: (indexPath)) {
                        
                        NotificationCenter.default.removeObserver(cell)
                        
                        self.configureCell(cell, atIndexPath: indexPath)
                        
                        self.startCell(cell, atIndexPath:indexPath)
                        
                        let headerView = self.tableView?.headerView(forSection: indexPath.section)
                        
                        //if headerView.respondsTo respondsToSelector:@selector(update)]) {
                        //    [headerView performSelector:@selector(update)];
                        //}
                        
                        headerView?.setNeedsDisplay()
                        headerView?.setNeedsLayout()
                    }
                }
                break;
                
            case .move:
                if let indexPath = indexPath {
                    if let newIndexPath = newIndexPath {
                        self.tableView?.deleteRows(at: [indexPath], with: UITableViewRowAnimation.none)
                        self.tableView?.insertRows(at: [newIndexPath], with: UITableViewRowAnimation.none)
                    }
                }
                break;
            }
        }
    }
    
    internal func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if (self.navigationController?.viewControllers.last?.isEqual(self))!{
            
            self.tableView?.endUpdates()
        }else{
            self.tableView?.reloadData()
        }
    }
}
