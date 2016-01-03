//
//  Places.swift
//  Fuot
//
//  Created by Zoom Nguyen on 1/3/16.
//  Copyright © 2016 Zoom Nguyen. All rights reserved.
//

import Foundation
import CoreData
import Parse

@objc(Places)
class Places: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    
    /* SYNC DATA FROM PARSE */
    static func syncPlacesWithParse(completion:()->Void){
        //Get Data from Parse
        let query = PFQuery(className:"Place")
        
        if let placeLatest:Places = Places.fetchLatestObject(){
            query.whereKey("updatedAt", greaterThan:placeLatest.updatedAt!)
        }
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) places.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        
                        Places.deleteObject(object.objectId!)
                        
                        let place = Places.createNewEntity() as! Places
                        place.objectId = object.objectId
                        place.createdAt = object.createdAt
                        place.updatedAt = object.updatedAt
                        
                    }
                    Places.saveToDefaultContext()
                    completion()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                
            }
        }
    }

    
    
    /* FETCH ALL */
    static func fetchAll() -> NSArray{
        return Places.findAll()
    }
    
    /* FETCH OBJECT BY ID */
    static func fetchByObjectID(objectID:String)->Places?{
        let predicate = NSPredicate(format: "objectId = %@",objectID)
        let arrayOjects = Places.findAllWithPredicate(predicate)
        
        if let place:Places = arrayOjects.firstObject as? Places {
            return place
        }
        return nil
    }
    
    /* FETCH LATEST OBJECT */
    static func fetchLatestObject() -> Places?{
        let arrayObjects = Places.findAll()
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: false)
        let sortedResults: NSArray = arrayObjects.sortedArrayUsingDescriptors([descriptor])
        
        if let place:Places = sortedResults.firstObject as? Places{
            return place
        }
        return nil
    }
    
    /* DELETE OBJECT */
    static func deleteObject(objectID:String){
        if let place:Places = Places.fetchByObjectID(objectID){
            let context = Places.getContext()
            context.deleteObject(place)
        }
    }
    
    /* CONTEXT */
    static func saveToDefaultContext() {
        let context =  SuperCoreDataStack.defaultStack.managedObjectContext
        do {
            try context!.save()
        } catch {
            abort()
        }
        
    }
    
    static private func getContext()-> NSManagedObjectContext{
        return SuperCoreDataStack.defaultStack.managedObjectContext!
    }
}
