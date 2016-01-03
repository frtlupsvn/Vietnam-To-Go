//
//  ParseObject+CoreDataProperties.swift
//  Fuot
//
//  Created by Zoom Nguyen on 1/3/16.
//  Copyright © 2016 Zoom Nguyen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ParseObject {

    @NSManaged var objectId: String?
    @NSManaged var createdAt: NSDate?
    @NSManaged var updatedAt: NSDate?

}
