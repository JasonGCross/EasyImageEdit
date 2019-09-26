//
//  ContentView.swift
//  LiveSurfaceImageEditor
//
//  Created by Jason Cross on 9/26/19.
//  Copyright © 2019 Jason Cross. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    @Environment(\.managedObjectContext)
    var viewContext   
 
    var body: some View {
        NavigationView {
            MasterView()
                .navigationBarTitle("Master")
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
        CollectionViewOfCards(images:Array(images))
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
    
    var body: some View {
        HStack {
            ForEach(images, id: \.uuid) { imageModel in
                Text("\(imageModel.name!)")
            }
        }
    }
}

struct CollectionViewOfCards : View {
    var images: Array<ImageModel>
    
    let maxNumberOfCardsPerRow = 2
    
    var body: some View {
        var row : Int = 0
        
        var rowData : Array<ImageModel> = Array<ImageModel>()
        return List {
            ForEach(images, id: \.self) { imageModel -> RowOfCards? in
                guard let index = self.images.firstIndex(of: imageModel) else {
                    return nil
                }
                
                let thisIsTheStartOfANewRow = 0 == (index % self.maxNumberOfCardsPerRow)
                if (index >= self.maxNumberOfCardsPerRow) && thisIsTheStartOfANewRow {
                    row += 1
                    rowData = Array<ImageModel>()
                }
                rowData.append(imageModel)
                
                // only return when at the end of the array
                // or at the end of a row
                if (index == (self.images.count - 1)) ||
                    (self.maxNumberOfCardsPerRow == rowData.count) {
                    return RowOfCards(images: rowData)
                }
                return nil
            }
        }
    }
}
