//
//  CityType.swift
//  Fuot
//
//  Created by Zoom Nguyen on 12/31/15.
//  Copyright © 2015 Zoom Nguyen. All rights reserved.
//

import Foundation
import CoreData
import Parse

@objc(CityType)
class CityType: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    static func fetchAllCityType() -> NSArray{
        return CityType.findAll()
    }
    
    // Sync Data
    static func syncCityTypeWithParse(completion:()->Void){
        //Get Data from Parse
        let query = PFQuery(className:"CityType")
        
        if let cityTypeLatest:CityType = CityType.getCityLatestFromDB(){
            query.whereKey("updatedAt", greaterThan:cityTypeLatest.updatedAt!)
        }
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) categories.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        
                        CityType.deleteCityIfExistInDB(object.objectId!)
                        
                        let cityType = CityType.createNewEntity() as! CityType
                        cityType.objectId = object.objectId
                        cityType.createdAt = object.createdAt
                        cityType.updatedAt = object.updatedAt
                        
                        cityType.nameCityType = object["nameCityType"] as? String

                        
                    }
                    CityType.saveToDefaultContext()
                    completion()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                
            }
        }
    }
    
    static func deleteCityIfExistInDB(objectId:String){
        let predicate = NSPredicate(format: "objectId = %@",objectId)
        let cityTypes = CityType.findAllWithPredicate(predicate)
        
        if let cityType:CityType = cityTypes.firstObject as? CityType{
            let context = CityType.getContext()
            context.deleteObject(cityType)
        }
    }
    
    static func getCityTypeWithId(objectId:String)->CityType?{
        
        let predicate = NSPredicate(format: "objectId = %@",objectId)
        let cityTypes = CityType.findAllWithPredicate(predicate)
        
        if let cityType:CityType = cityTypes.firstObject as? CityType {
            return cityType
        }
        return nil
    }
    
    static func getCityTypeWithnameCityType(nameCityType:String)->CityType?{
        
        let predicate = NSPredicate(format: "nameCityType = %@",nameCityType)
        let cityTypes = CityType.findAllWithPredicate(predicate)
        
        if let cityType:CityType = cityTypes.firstObject as? CityType {
            print(cityType.nameCityType)
            return cityType
        }
        return nil
    }
    
    static func getCityLatestFromDB() -> CityType?{
        //Get latest updatedAt in Local DB
        let arrayAllCityType = CityType.findAll()
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: false)
        let sortedResults: NSArray = arrayAllCityType.sortedArrayUsingDescriptors([descriptor])
        
        if let cityType:CityType = sortedResults.firstObject as? CityType{
            return cityType
        }
        return nil
    }
    
    // Update Context
    
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
