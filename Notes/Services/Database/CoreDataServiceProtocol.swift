//
//  CoreDataServiceProtocol.swift
//  Copyright © 2016 ArtyGeek. All rights reserved.
//

import CoreData

protocol CoreDataServiceProtocol {
    func saveStoredData() -> Void
    func execute(fetchRequest: NSFetchRequest<NSFetchRequestResult>) -> [AnyObject]?
    func insertObject(forEntityName name: String) -> NSManagedObject
    func getObjects(forEntityName name: String, predicate: NSPredicate?) -> [AnyObject]?
    func countObjects(forEntityName name: String, predicate: NSPredicate?) -> Int
    func delete(object: NSManagedObject) -> Void
}
