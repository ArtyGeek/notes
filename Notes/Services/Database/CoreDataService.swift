//
//  CoreDataService.swift
//  Copyright © 2016 ArtyGeek. All rights reserved.
//

import UIKit
import CoreData

class CoreDataService: CoreDataServiceProtocol {

    static let shared = CoreDataService()
    
    //MARK: Private vars
    
    private let managedObjectContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    //MARK: Lifecycle
    
    private init() { }

    //MARK: CoreDataServiceProtocol
    
    func saveStoredData() {
        do {
            try self.managedObjectContext.save()
        } catch let error as NSError {
            _handleError(error: error)
        }
    }
    
    func execute(fetchRequest: NSFetchRequest<NSFetchRequestResult>) -> [AnyObject]? {
        do {
            return try self.managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError {
            _handleError(error: error)
        }
        return nil
    }
    
    func insertObject(forEntityName name: String) -> NSManagedObject {
        return NSEntityDescription.insertNewObject(forEntityName: name, into: self.managedObjectContext)
    }
    
    func getObjects(forEntityName name: String, predicate: NSPredicate? = nil) -> [AnyObject]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        fetchRequest.predicate = predicate
        return execute(fetchRequest: fetchRequest)
    }
    
    func countObjects(forEntityName name: String, predicate: NSPredicate? = nil) -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        fetchRequest.predicate = predicate
        do {
            return try self.managedObjectContext.count(for: fetchRequest)
        } catch let error as NSError {
            _handleError(error: error)
        }
        return 0
    }
    
    func delete(object: NSManagedObject) {
        self.managedObjectContext.delete(object)
    }
    
    //MARK: Private methods
    
    private func _handleError(error: NSError) {
        print("Error: \(error.localizedDescription)")
    }
}
