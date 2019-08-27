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
    var emptyCellIdentifier: String = "Cell"
    
    private var _fetchedResultsController:NSFetchedResultsController<NSManagedObject>?
    var managedObjectContext:NSManagedObjectContext?
    
    var entityName:String?
    var sectionKeyPath:String?
    
    var predicates = [NSPredicate]()
    var searchPredicate: NSPredicate?
    
    var sortDescriptors = [NSSortDescriptor]()
    
    var fetchLimit:Int = 0

    var propertiesToFetch: [String]? = nil
    
    var firstTimeOpened = true
    
    var dynamicUpdate = true
    
    var noDataInfo: String? {
        didSet{
            self.noContentView.text = noDataInfo
        }
    }
    var minSectionCount: Int = 0
    
    var noContentView = UILabel()
    
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
        log("WARNING: You have to override this method to set cellIdentifier, managedObjectContext, entityName, predicates and sortDescriptors")
    }
    
    // MARK: View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noContentView.textAlignment = .center
        self.noContentView.isHidden = true
        self.noContentView.numberOfLines = 0
        self.noContentView.frame = CGRect(x: self.tableView.bounds.origin.x,
                                          y: self.tableView.bounds.origin.y + (self.tableView.tableHeaderView?.bounds.size.height ?? 0),
                                          width: self.tableView.bounds.size.width,
                                          height: self.tableView.rowHeight)
        self.noContentView.backgroundColor = UIColor.clear //.withAlphaComponent(0.5)
        self.view.addSubview(noContentView)
        
        self.view.bringSubviewToFront(noContentView)
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true
        
 
    }
    override func updateAppearance() {
        super.updateAppearance()
        
        let theme = ThemeManager.currentTheme()
        
        self.noContentView.text = noDataInfo ?? "–"
        self.noContentView.textColor = theme.highlightTextColor
        self.noContentView.font = UIFont(name: kFontRegular, size: 16)
        self.noContentView.frame = CGRect(x: self.tableView.bounds.origin.x,
                                          y: self.tableView.bounds.origin.y + (self.tableView.tableHeaderView?.bounds.size.height ?? 0),
                                          width: self.tableView.bounds.size.width,
                                          height: self.tableView.rowHeight)
    }
//    override func updateViewConstraints() {
//
//        self.noContentView.autoPinEdgesToSuperviewMargins()
//
//        super.updateViewConstraints()
//    }
    func refreshHeader() {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self._fetchedResultsController?.delegate = self
        
        //if firstTimeOpened == false{
            if self.refetchData() {
                self.tableView.reloadData()
            }
        //}
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
        
        self._fetchedResultsController?.delegate = nil
        
        super.viewDidDisappear(animated)
    }
    
    // MARK: UITableView DataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        var count = 0
        
        if let sections = self.fetchedResultsController.sections{
            count = sections.count
        }
        
        if count < minSectionCount{
            count = minSectionCount
        }
        
        return count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if let sections = self.fetchedResultsController.sections{
            
            if sections.count > section {
                
                let sectionInfo = sections[section]
                
                count = sectionInfo.numberOfObjects
            }
        }
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let sections = self.fetchedResultsController.sections, sections.count > 0, let _ = self.object(at: indexPath)  {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
            
            self.configureCell(cell, atIndexPath: indexPath)
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.emptyCellIdentifier, for: indexPath)
        self.configureEmptyCell(cell, atIndexPath: indexPath)
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
        
        log("time to override this method ->", "func configureCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)")
        
        if let object = self.object(at: indexPath) {
        
            cell.textLabel?.text = object.objectID.description
        }
    }
    func configureEmptyCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath) {
        cell.selectionStyle = .none
        if let info = noDataInfo {
            cell.textLabel?.text = info
        }
    }
    func startCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath){
        
        log("time to override this method ->", "func startCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)")
    }
    func updateCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath){
        log("time to override this method ->", "func updateCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)")
        
        
    }
    func unloadCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath){
        
        log("time to override this method ->", "func unloadCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)\n Dont forget to NotificationCenter.default.removeObserver(cell) ")
        
        NotificationCenter.default.removeObserver(cell)
    }
    
    // MARK: Fetch Result Controller
    
    var fetchedResultsController: NSFetchedResultsController<NSManagedObject> {
        if let fetchedResultsController = self._fetchedResultsController{
            
            return fetchedResultsController
        }
        if let context = self.managedObjectContext{
            let fetchRequest:NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: self.entityName!)
 

            if let properties = propertiesToFetch {
                fetchRequest.returnsObjectsAsFaults = true
                fetchRequest.propertiesToFetch = properties
            } else {
                fetchRequest.returnsObjectsAsFaults = false
            }

            fetchRequest.fetchBatchSize = 10

            if self.sortDescriptors.count > 0 {
                fetchRequest.sortDescriptors = sortDescriptors;
            }


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

        if let properties = propertiesToFetch {
            resultController.fetchRequest.returnsObjectsAsFaults = true
            resultController.fetchRequest.propertiesToFetch = properties
        } else {
            resultController.fetchRequest.returnsObjectsAsFaults = false
        }

        do {
            try resultController.performFetch()
            
            self.refreshHeader()
            
            if let objects = resultController.fetchedObjects, objects.count > 0 {
                //inhalt ist da, wird angezeigt
                hideNoContentView()
            }else{
                showNoContentView()
            }
            
            return true
        } catch {
            let fetchError = error as NSError
            log("\(fetchError), \(fetchError.userInfo)")
        }
        return false
    }
    func showNoContentView() {
        self.noContentView.isHidden = false
    }
    func hideNoContentView() {
        self.noContentView.isHidden = true
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
        
        if let sections = self.fetchedResultsController.sections, sections.count > section {
        
            if let sectionObjects = sections[section].objects as? [NSManagedObject]{
                return sectionObjects
            }
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
//                log("insert section \(sectionIndex)")
                self.tableView?.insertSections(IndexSet(integer: sectionIndex), with: .middle)
                break
                
            case .delete:
//                log("delete section \(sectionIndex)")
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
//                    log("insert \(newIndexPath)")
                    self.tableView?.insertRows(at: [newIndexPath], with: .middle)
                }
                break;
                
            case .delete:
                if let indexPath = indexPath {
//                    log("delete \(indexPath)")
                    let cell = self.tableView?.cellForRow(at: indexPath)
                    
                    NotificationCenter.default.removeObserver(cell as Any)
                    
                    self.tableView?.deleteRows(at: [indexPath], with: .middle)
                }
                break;
                
            case .update:
                if let indexPath = indexPath {
//                    log("update \(indexPath)")
                    if let cell = self.tableView?.cellForRow(at: indexPath) {
                        self.updateCell(cell, atIndexPath:indexPath)
                    }
                }
                break;
                
            case .move:
                if let from = indexPath, let to = newIndexPath {
//                    log("move \(from) to \(to)")
                    
                    if let cell = self.tableView?.cellForRow(at: from) {
                        self.updateCell(cell, atIndexPath:from)
                    }
                    
                    self.tableView?.moveRow(at: from, to: to)
                    
                    
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
            @unknown default:
                //keine ahnung, nix tun
                break
            }
            self.refreshHeader()
        }
    }
    
    internal func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        if (self.navigationController == nil ||
            (self.navigationController != nil && (self.navigationController?.viewControllers.last?.isEqual(self))!)) && self.dynamicUpdate == true{
            
            self.tableView?.endUpdates()
            
//            if noDataInfo != nil {
//
//                let sectionNumbers = self.numberOfSections(in: self.tableView)
//
//                if let sections = self.fetchedResultsController.sections{
//                    for s in 0..<sectionNumbers{
//
//                        if sections.count > s {
//
//                            let sectionInfo = sections[s]
//
//                            if sectionInfo.numberOfObjects == 1 {
//                                self.tableView.reloadSections(IndexSet(integer: s), with: .automatic)
//                            }
//                        }
//                    }
//                }
//            }
            
            
            self.refreshHeader()
        }else{
            self.tableView?.reloadData()
            self.refreshHeader()
            self.dynamicUpdate = true
        }
    }
    

}
