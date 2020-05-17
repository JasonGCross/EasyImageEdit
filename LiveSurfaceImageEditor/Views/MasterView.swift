//
//  MasterView.swift
//  LiveSurfaceImageEditor
//
//  Created by Jason Cross on 2020-04-12.
//  Copyright © 2020 Jason Cross. All rights reserved.
//

import SwiftUI
import CoreData

struct MasterView: View {
    @FetchRequest(fetchRequest: ImageModel.allImagesFetchRequest()) var images: FetchedResults<ImageModel>

    @Environment(\.managedObjectContext) var viewContext

    var body: some View {
        
        CollectionViewOfCards(
            images:Array(images))
        .onAppear {
            // if there are no images, fetch them now
            let fetch = NSFetchRequest<NSManagedObject>(entityName: "ImageModel")
            fetch.predicate = NSPredicate(format: "index != nil")
            if let foundImages = (try? self.viewContext.fetch(fetch)) as? Array<ImageModel>,
                foundImages.count > 0 {
                print("images already downloaded: \(foundImages)")
            }
            else {
                // this custom publisher does not return any data. instead, the images are stored using CoreData.
                // but we do need to upate the UI when the promises reports completion with no error
                let _ = JGCDataManager.sharedManager.fetchAllImageDetailsFromServer()
            }
        }
    }
}

struct MasterView_Previews: PreviewProvider {
    static var previews: some View {
        MasterView()
    }
}
