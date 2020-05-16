//
//  JGCDataManager.swift
//  LiveSurfaceImageEditor
//
//  Created by Jason Cross on 9/26/19.
//  Copyright © 2019 Jason Cross. All rights reserved.
//

import UIKit
import Combine
import CoreData


final class JGCDataManager {
    
    static let sharedManager = JGCDataManager()
    
    lazy var managedObjectContext = {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }()
    
    
    // MARK: - API Interaction
    
    public func fetchAllImageDetailsFromServer() -> AnyPublisher<Void, Error> {
        let urlString = "https://www.livesurface.com/test/api/images.php?key=6169f2a5-35ba-4478-83a4-78aac557197b"
        let urlComponents = URLComponents.init(string: urlString)
        guard let urlObject = urlComponents?.url else {
            preconditionFailure("malformed URL")
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlObject)
            .map {$0.data}
            .tryMap { data in
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any>,
                let entityDescription = NSEntityDescription.entity(forEntityName: "ImageModel", in: self.managedObjectContext) {
            
                // each key is a UUID; each value is a child JSON dictionary
                for (key, value) in jsonData {
                    if var childJson = value as? Dictionary<String, Any> {
                        childJson["uuid"] = key
                        self.managedObjectContext.performAndWait {
                            do {
                            let _ = JSONDeserializationToNSManagedObject.upsertManagedObjectFromJSON(
                                json: childJson,
                                entity: entityDescription,
                                managedObjectContext: self.managedObjectContext)
                                
                                try self.managedObjectContext.save()
                            }
                            catch {
                                print("failed to download images")
                            }
                        }
                    }
                }
            }
                
        }
        .eraseToAnyPublisher()


    }
    
}
