//
//  CityType+CoreDataProperties.swift
//  Fuot
//
//  Created by Zoom Nguyen on 12/31/15.
//  Copyright © 2015 Zoom Nguyen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CityType {

    @NSManaged var nameCityType: String?
    @NSManaged var createdAt: NSDate?
    @NSManaged var updatedAt: NSDate?
    @NSManaged var objectId: String?

}
