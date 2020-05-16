//
//  RowOfCards.swift
//  LiveSurfaceImageEditor
//
//  Created by Jason Cross on 2020-04-12.
//  Copyright © 2020 Jason Cross. All rights reserved.
//

import SwiftUI
import CoreData

/// A row of cards just displays cards in a horizontal stack
struct RowOfCards: View {
    var images : Array<ImageModel>
    @Binding var zoomFactor : Float
    
    var body: some View {
        HStack {
            ForEach(images, id: \.uuid) { imageModel in
                Card(imageModel:imageModel, zoomFactor: self.$zoomFactor)
                .fixedSize()
                    .frame(
                        width: CGFloat(self.zoomFactor) * Card.defaultCardSize.width,
                        height: CGFloat(self.zoomFactor) * Card.defaultCardSize.height)
                    .clipped(antialiased: false)
            }
        }
    }
}

struct RowOfCards_Previews: PreviewProvider {
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
        guard images.count > 0 else {
                preconditionFailure()
        }

        return RowOfCards(images: images, zoomFactor: .constant(1.0))
    }
}
