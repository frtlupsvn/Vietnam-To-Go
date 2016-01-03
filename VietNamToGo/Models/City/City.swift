//
//  City.swift
//  VietNamToGo
//
//  Created by Zoom Nguyen on 12/25/15.
//  Copyright © 2015 Zoom Nguyen. All rights reserved.
//

import Foundation
import CoreData
import Parse

@objc(City)
class City: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    
    // Sync Data
    
    static func syncCityWithParse(completion:()->Void){
        
        //Get Data from Parse
        let query = PFQuery(className:"City")
        
        if let cityLatest:City = City.getCityLatestFromDB(){
            query.whereKey("updatedAt", greaterThan:cityLatest.updatedAt!)
        }
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) cities.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        
                        City.deleteCityIfExistInDB(object.objectId!)
                        
                        let city = City.createNewEntity() as! City
                        city.objectId = object.objectId
                        city.createdAt = object.createdAt
                        city.updatedAt = object.updatedAt
                        
                        city.name = object["name"] as? String
                        city.cityShortDescription =  object["shortDescription"] as? String
                        //Cache Image
                        if let imageFile = object["cityImage"]{
                            city.cityImage = imageFile.url
                        }
                        
                        if let typeParseObject:PFObject = object["type"] as? PFObject{
                            if let cityType = CityType.getCityTypeWithId(typeParseObject.objectId!) {
                                city.type = cityType
                            }
                        }

                    }
                    City.saveToDefaultContext()
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
        let cities = City.findAllWithPredicate(predicate)
        
        if let city:City = cities.firstObject as? City{
            let context = City.getContext()
            context.deleteObject(city)
        }
    }
    
    static func getCityLatestFromDB() -> City?{
        //Get latest updatedAt in Local DB
        let arrayAllCity = City.fetchAllCity()
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: false)
        let sortedResults: NSArray = arrayAllCity.sortedArrayUsingDescriptors([descriptor])
        
        if let city:City = sortedResults.firstObject as? City{
            return city
        }
        return nil
    }
    
    // Fetch from DB
    
    static func fetchAllCity() -> NSArray{
        return City.findAll()
    }
    
    static func fetchCityWithType(cityType:CityType) -> NSArray {
        let predicate = NSPredicate(format: "type = %@",cityType)
        let cities = City.findAllWithPredicate(predicate)
        
        return cities
    }
    
    // Delete
    
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
