//
//  Tags.swift
//  LiveSurfaceImageEditor
//
//  Created by Jason Cross on 2020-05-16.
//  Copyright © 2020 Jason Cross. All rights reserved.
//

import SwiftUI
import CoreData

extension Tags {
    
    static func create(in managedObjectContext: NSManagedObjectContext) -> Tags {
        let tags = self.init(context: managedObjectContext)
        
        tags.sizewidth = "157.000"
        tags.sizeheight = "208.000"
        tags.sizeunits = "mm"
        tags.sizescale = "1.000"
        
        do {
            try  managedObjectContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return tags
    }
}
