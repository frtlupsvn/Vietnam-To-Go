//
//  Places+CoreDataProperties.swift
//  Fuot
//
//  Created by Zoom Nguyen on 1/4/16.
//  Copyright © 2016 Zoom Nguyen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Places {

    @NSManaged var namePlace: String?
    @NSManaged var othernamePlace: String?
    @NSManaged var descriptionPlace: String?
    @NSManaged var estimationPlace: NSNumber?
    @NSManaged var longtitude: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var imageUrlPlace: String?
    @NSManaged var objectId: String?
    @NSManaged var updatedAt: NSDate?
    @NSManaged var createdAt: NSDate?

}
