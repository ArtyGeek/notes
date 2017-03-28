//
//  Note.swift
//  Copyright © 2016 ArtyGeek. All rights reserved.
//

import CoreData

class Note: NSManagedObject {
    @NSManaged var id: NSNumber!
    @NSManaged var text: String?
    
    @NSManaged var metadata: Metadata!
    
    override func didChangeValue(forKey key: String) {
        super.didChangeValue(forKey: key)
        
        if key == "text" {
            metadata.editedDate = Date()
        }
    }
}
