//
//  ContentView.swift
//  LiveSurfaceImageEditor
//
//  Created by Jason Cross on 9/26/19.
//  Copyright © 2019 Jason Cross. All rights reserved.
//

import SwiftUI
import CoreData
import Combine



struct ContentView: View {
    @Environment(\.managedObjectContext)
    var viewContext   
 
    var body: some View {
        NavigationView {
            MasterView()
                .navigationBarTitle("Images")
                .navigationBarItems(
                    leading: EditButton(),
                    trailing: Button(
                        action: {
                            withAnimation { ImageModel.create(in: self.viewContext) }
                        }
                    ) { 
                        Image(systemName: "plus")
                    }
                )
            Text("Detail view content goes here")
                .navigationBarTitle("Detail")
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct MasterView: View {
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    var images: FetchedResults<ImageModel>

    @Environment(\.managedObjectContext)
    var viewContext

    var body: some View {
        // if there are no images, fetch them now
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "ImageModel")
        fetch.predicate = NSPredicate(format: "index != nil")
        if let foundImages = (try? self.viewContext.fetch(fetch)) as? Array<ImageModel>,
            foundImages.count > 0 {
            print("images already downloaded: \(foundImages)")
        }
        else {
            JGCDataManager.sharedManager.fetchAllImageDetailsFromServer()
        }
        
        return CollectionViewOfCards(
            images:Array(images))
    }
}

struct DetailView: View {
    @ObservedObject var imageModel: ImageModel

    var body: some View {
        Text("\(imageModel.name!)")
            .navigationBarTitle("Detail")
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}

/// A row of cards just displays cards in a horizontal stack
struct RowOfCards: View {
    var images : Array<ImageModel>
    @Binding var zoomFactor : Float
    
    var body: some View {
        
        let cardWidth = CGFloat(self.zoomFactor) * Card.defaultCardSize.width
        let cardHeight = CGFloat(self.zoomFactor) * Card.defaultCardSize.height
        
        return HStack {
            ForEach(images, id: \.uuid) { imageModel in
                Card(imageModel:imageModel, zoomFactor: self.$zoomFactor)
                .fixedSize()
                    .frame(
                        width: cardWidth,
                        height: cardHeight)
                    .clipped(antialiased: false)
            }
        }
    }
}

struct CollectionViewOfCards : View {
    var images: Array<ImageModel>
    @State private var zoomFactor: Float = 1.0
    
    
    var body: some View {
        
        let currentAvailableWidth : Float = 300
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
                        
                        let thisIsTheStartOfANewRow = 0 == (index % maxNumberOfCardsPerRow)
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

/// a single collection view cell, which is called a "card"
/// because it it like a sports card, with a photo and some metadata
struct Card: View {
    let imageModel: ImageModel
    static let defaultCardSize = CGSize(width: 80, height: 120)
    private static let defaultFontSize = Float(12)
     @Binding var zoomFactor : Float
    
    var body: some View {
        
        let scaledFontSize = CGFloat(Card.defaultFontSize * zoomFactor)
        let scaledFont = Font.system(
            size:scaledFontSize,
            weight: Font.Weight.regular,
            design: Font.Design.default)
        
        return VStack {
            Image(systemName:"photo")
            Text("\(imageModel.name!)").font(scaledFont)
            Text("\(imageModel.category!)").font(scaledFont)
        }.padding()
    }
}
