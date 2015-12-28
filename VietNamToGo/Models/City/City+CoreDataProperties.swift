//
//  City+CoreDataProperties.swift
//  VietNamToGo
//
//  Created by Zoom Nguyen on 12/25/15.
//  Copyright © 2015 Zoom Nguyen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension City {

    @NSManaged var objectId: String?
    @NSManaged var name: String?
    @NSManaged var createdAt: NSDate?
    @NSManaged var updatedAt: NSDate?
    @NSManaged var cityShortDescription: String?
    @NSManaged var cityImage: String?

}
