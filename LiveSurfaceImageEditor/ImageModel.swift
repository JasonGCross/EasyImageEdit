//
//  ImageModel.swift
//  LiveSurfaceImageEditor
//
//  Created by Jason Cross on 9/26/19.
//  Copyright © 2019 Jason Cross. All rights reserved.
//

import SwiftUI
import CoreData

extension ImageModel {
    
    static func create(in managedObjectContext: NSManagedObjectContext) {
        let newImageModel = self.init(context: managedObjectContext)
        
        newImageModel.uuid = UUID()
        newImageModel.name = "my sample image"
        newImageModel.category = "testing"
        
        do {
            try  managedObjectContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
}
