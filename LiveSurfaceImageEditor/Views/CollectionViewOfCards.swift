//
//  CollectionViewOfCards.swift
//  LiveSurfaceImageEditor
//
//  Created by Jason Cross on 2020-04-12.
//  Copyright © 2020 Jason Cross. All rights reserved.
//

import SwiftUI
import CoreData

struct CollectionViewOfCards: View {
    var images: Array<ImageModel>
    @State private var zoomFactor: Float = 1.0
    private static let paddingInsideRow: Float = 16.0
    
    var body: some View {
        
        let currentAvailableWidth : Float = 300 - CollectionViewOfCards.paddingInsideRow
        var row : Int = 0
        let defaultCardWidth = Float(Card.defaultCardSize.width) * self.zoomFactor
        let maxNumberOfCardsPerRow = Int(trunc(currentAvailableWidth / defaultCardWidth))
        var rowData : Array<ImageModel> = Array<ImageModel>()
        
        return
            VStack {
                VStack {
                    Slider(value: $zoomFactor, in: 0.25...3.0, step: 0.05)
                }.padding()
                List {
                    ForEach(images, id: \.self) { imageModel -> RowOfCards? in
                        guard let index = self.images.firstIndex(of: imageModel) else {
                            return nil
                        }
                        
                        let thisIsTheStartOfANewRow = (0 == maxNumberOfCardsPerRow) ? true : (0 == (index % maxNumberOfCardsPerRow))
                        if (index >= maxNumberOfCardsPerRow) && thisIsTheStartOfANewRow {
                            row += 1
                            rowData = Array<ImageModel>()
                        }
                        rowData.append(imageModel)
                        
                        // only return when at the end of the array
                        // or at the end of a row
                        if (index == (self.images.count - 1)) ||
                            (maxNumberOfCardsPerRow == rowData.count) {
                            return RowOfCards(images: rowData, zoomFactor: self.$zoomFactor)
                        }
                        return nil
                    }
                }
        }
            
    }
}

struct CollectionViewOfCards_Previews: PreviewProvider {
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
        
        return CollectionViewOfCards(images: images)
    }
}
