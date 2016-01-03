//
//  ParseObject.swift
//  Fuot
//
//  Created by Zoom Nguyen on 1/3/16.
//  Copyright © 2016 Zoom Nguyen. All rights reserved.
//

import Foundation
import CoreData
import Parse

@objc(ParseObject)
class ParseObject: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    // Update Context
    static func saveToDefaultContext() {
        let context =  SuperCoreDataStack.defaultStack.managedObjectContext
        do {
            try context!.save()
        } catch {
            abort()
        }
        
    }
    
    static func getContext()-> NSManagedObjectContext{
        return SuperCoreDataStack.defaultStack.managedObjectContext!
    }

}
