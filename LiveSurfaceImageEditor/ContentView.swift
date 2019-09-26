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
        List {
            ForEach(images, id: \.self) { imageModel in
                NavigationLink(
                    destination: DetailView(imageModel: imageModel)
                ) {
                    Text("\(imageModel.name!)")
                }
            }
//            .onDelete { indices in
//                self.images.delete(at: indices, from: self.viewContext)
//            }
        }
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
