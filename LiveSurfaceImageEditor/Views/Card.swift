//
//  Card.swift
//  LiveSurfaceImageEditor
//
//  Created by Jason Cross on 2020-04-12.
//  Copyright © 2020 Jason Cross. All rights reserved.
//

import SwiftUI
import CoreData

/// a single collection view cell, which is called a "card"
/// because it it like a sports card, with a photo and some metadata
struct Card: View {
    let imageModel: ImageModel
    static let defaultCardSize = CGSize(width: 100, height: 200)
    private static let defaultFontSize = Float(10)
    private static let paddingInsideCard = CGFloat(3.0)
    @Binding var zoomFactor : Float
    
    var body: some View {
        
        let scaledFontSize = CGFloat(Card.defaultFontSize * zoomFactor)
        let scaledFont = Font.system(
            size:scaledFontSize,
            weight: Font.Weight.regular,
            design: Font.Design.default)
        
        return VStack {
            Image(systemName:"photo")
                .resizable()
                .aspectRatio(contentMode: ContentMode.fit)
                .frame(width: Card.defaultCardSize.width * 0.9 * CGFloat(zoomFactor),
                       height: Card.defaultCardSize.width * 0.9 * CGFloat(zoomFactor))
            VStack(alignment: .leading) {
                Text("\(imageModel.name ?? "")")
                    .font(scaledFont)
                    .foregroundColor(Color.orange)
                    .lineLimit(1)
                Text("\(imageModel.number ?? "")")
                    .font(scaledFont)
                    .foregroundColor(Color.white)
                    .lineLimit(1)
                Text("\(imageModel.image ?? "")")
                    .font(scaledFont)
                    .foregroundColor(Color.white)
                    .lineLimit(1)
                Text("\(imageModel.category ?? "")")
                    .font(scaledFont)
                    .foregroundColor(Color.white)
                    .lineLimit(1)
                Text("version: \(imageModel.version ?? "")")
                    .font(scaledFont)
                    .foregroundColor(Color.white)
                    .lineLimit(1)
                Text("\(imageModel.tags?.sizewidth ?? "0") x \(imageModel.tags?.sizeheight ?? "0") \(imageModel.tags?.sizeunits ?? "")")
                    .font(scaledFont)
                    .foregroundColor(Color.white)
                    .lineLimit(1)
                Text("scale: \(imageModel.tags?.sizescale ?? "")")
                    .font(scaledFont)
                    .foregroundColor(Color.white)
                    .lineLimit(1)
            }
        }
            .frame(width: Card.defaultCardSize.width * CGFloat(zoomFactor),
                   height: Card.defaultCardSize.height * CGFloat(zoomFactor))
            .padding(Card.paddingInsideCard)
            .background(LinearGradient(
                gradient: Gradient(colors: [.blue, .black]),
                startPoint: .top,
                endPoint: .bottom
            ))
    }
}

struct Card_Previews: PreviewProvider {
    
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
        
        return Card(imageModel: imageModel,
                    zoomFactor:.constant(1.0))
    }
}
