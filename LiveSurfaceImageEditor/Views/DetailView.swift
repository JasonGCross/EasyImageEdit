//
//  DetailView.swift
//  LiveSurfaceImageEditor
//
//  Created by Jason Cross on 2020-04-12.
//  Copyright © 2020 Jason Cross. All rights reserved.
//

import SwiftUI
import CoreData

struct DetailView: View {
    @ObservedObject var imageModel: ImageModel

    var body: some View {
        Text("\(imageModel.name!)")
            .navigationBarTitle("Detail")
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let moc = JGCDataManager.sharedManager.managedObjectContext
        ImageModel.create(in: moc)
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "ImageModel")
        guard var images = (try? moc.fetch(fetch)) as? Array<ImageModel> else {
            preconditionFailure()
        }
        if (images.count < 1) {
            ImageModel.create(in: moc)
        }
        
        images = (try? moc.fetch(fetch)) as? Array<ImageModel> ?? Array<ImageModel>()
        guard images.count > 0,
            let imageModel : ImageModel = images.first else {
                preconditionFailure()
        }
        
        return DetailView(imageModel: imageModel)
    }
}
