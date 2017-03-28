//
//  Metadata.swift
//  Copyright © 2016 ArtyGeek. All rights reserved.
//

import Foundation
import CoreData

class Metadata: NSManagedObject {
    @NSManaged var createdDate: Date!
    @NSManaged var editedDate: Date?
}
