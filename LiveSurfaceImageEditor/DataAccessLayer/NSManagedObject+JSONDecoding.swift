//
//  NSManagedObject+JSONDecoding.swift
//  LiveSurfaceImageEditor
//
//  Created by Jason Cross on 9/26/19.
//  Copyright © 2019 Jason Cross. All rights reserved.
//

import Foundation


import Foundation
import CoreData

extension NSManagedObject {
    
    @objc func populateFromDictionary(_ incoming: [String: Any]) {
        let entity = self.entity
        for (key, _) in entity.attributesByName {
            // do NOT overwrite existing values if the incoming does not contain those keys
            if nil != incoming[key] {
                self.setValue(incoming[key], forKey:key)
            }
        }
        
        guard let moc = self.managedObjectContext else {
            fatalError("No context available")
        }
        
        for (name, relDesc) in entity.relationshipsByName {
            let childStructure = incoming[name]
            if (childStructure == nil) || (childStructure is NSNull) {
                continue
            }
            guard let destEntity = relDesc.destinationEntity else {
                fatalError("no destination entity assigned")
            }
            if relDesc.isToMany {
                guard let childArray = childStructure as? [[String: Any]] else {
                    fatalError("To-many relationship with malformed JSON")
                }
                var children = Set<NSManagedObject>()
                for child in childArray {
                    let mo = JSONDeserializationToNSManagedObject.upsertManagedObjectFromJSON(
                        json: child,
                        entity: destEntity,
                        managedObjectContext: moc)
                    children.insert(mo)
                }
                self.setValue(children, forKey: name)
            } else {
                guard let child = childStructure as? [String: Any] else {
                    fatalError("To-one relationship with malformed JSON")
                }
                let mo = JSONDeserializationToNSManagedObject.upsertManagedObjectFromJSON(
                    json: child,
                    entity: destEntity,
                    managedObjectContext: moc)
                self.setValue(mo, forKey: name)
            }
        }
    }
    
    @objc class func findExistingManagedObject(_ incoming: [String:Any], moc: NSManagedObjectContext) -> NSManagedObject? {
        
        return nil
    }
}

