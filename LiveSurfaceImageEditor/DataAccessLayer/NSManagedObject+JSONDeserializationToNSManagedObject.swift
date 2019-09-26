//
//  NSManagedObject+JSONDeserializationToNSManagedObject.swift
//  LiveSurfaceImageEditor
//
//  Created by Jason Cross on 9/26/19.
//  Copyright © 2019 Jason Cross. All rights reserved.
//

import Foundation


import Foundation
import CoreData



class JSONDeserializationToNSManagedObject {
    
    class func processJSONResponseIntoContex(
        jsonData: Data,
        entityName: String,
        context moc: NSManagedObjectContext) throws -> [NSManagedObjectID]? {
        
        let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
        
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: moc) else {
            fatalError("Unable to resolve \(entityName)")
        }
        
        switch json {
        case let single as [String:Any]:
            let item = upsertManagedObjectFromJSON(json:single, entity:entity, managedObjectContext: moc)
            return [item.objectID]
            
        case let array as [[String:Any]]:
            var arrayOfObjectIds = Array<NSManagedObjectID>()
            for jsonItem in array {
                let item = upsertManagedObjectFromJSON(json:jsonItem, entity:entity, managedObjectContext: moc)
                arrayOfObjectIds.append(item.objectID)
            }
            if (arrayOfObjectIds.count > 0) {
                return arrayOfObjectIds
            }
        default:
            break
        }
        
        return nil
    }
    
    class func upsertManagedObjectFromJSON (json childDict: [String:Any],
                                            entity:NSEntityDescription,
                                            managedObjectContext moc:NSManagedObjectContext) -> NSManagedObject  {
        
        // first try an update before an insert
        var managedObject: NSManagedObject?
        
        guard let classString = entity.name else {
            fatalError("could not get class name of NSEntityDescription: \(entity)")
        }
        
        guard let anyobjectype : AnyObject.Type = NSClassFromString(classString) else {
            fatalError("could not convert class string to Class for \(classString)")
        }
        
        guard let nsobjectype : NSManagedObject.Type = anyobjectype as? NSManagedObject.Type else {
            fatalError("could not get Class type of \(classString)")
        }
        
        moc.performAndWait {
            if let existingManagedObject = nsobjectype.findExistingManagedObject(childDict, moc: moc) {
                managedObject = existingManagedObject
            }
            else {
                managedObject = NSManagedObject(entity: entity,
                                                insertInto: moc)
            }
        }
        
        managedObject!.populateFromDictionary(childDict)
        return managedObject!
    }
}




