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
    
    public func fetchAllImageDetailsFromServer() {
        //TODO: get a newer API key
        let apiKeyIsCurrent = false
        
        if (apiKeyIsCurrent) {
            let urlString = "https://www.livesurface.com/test/api/images.php?key=6169f2a5-35ba-4478-83a4-78aac557197b"
            let urlComponents = URLComponents.init(string: urlString)
            guard let urlObject = urlComponents?.url else {
                preconditionFailure("malformed URL")
            }
            
            URLSession.shared.dataTask(with: urlObject) { (data, response, error) in
                guard nil == error else {
                    return
                }
                
                guard nil != response,
                    nil != data  else {
                        return
                }
                
                do {
                    if let jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as? Dictionary<String, Any>,
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
                catch {
                    //TODO: alert user something has gone wrong
                }
            }
        }
        
        else {
            let apiResponse = """
{
    "images": {
        "2CBA9F8B-0C1E-436B-A638-2A1C50FB94F5": {
            "index": 0,
            "name": "Packaging",
            "number": "0661",
            "image": "0661.jpg",
            "category": "category.default",
            "version": "1",
            "tags": {
                "sizedescription": "",
                "sizescale": "0.000",
                "sizewidth": "157.000",
                "sizewidtharc": "0",
                "sizeheight": "208.000",
                "sizeheightarc": "0",
                "sizedepth": "76.000",
                "sizedeptharc": "0",
                "sizeunits": "mm"
            }
        },
        "447DE767-E4BD-4BA5-B34E-EB42DA5F715D": {
            "index": 1,
            "name": "Textile",
            "number": "0673",
            "image": "0673.jpg",
            "category": "category.default",
            "version": "1",
            "tags": {
                "sizedescription": "",
                "sizescale": "1.000",
                "sizewidth": "0.000",
                "sizewidtharc": "0",
                "sizeheight": "0.000",
                "sizeheightarc": "0",
                "sizedepth": "0.000",
                "sizedeptharc": "0",
                "sizeunits": ""
            }
        },
        "7495F1A2-9080-4B0E-8BF1-3B1066EF5B27": {
            "index": 2,
            "name": "Packaging",
            "number": "0675",
            "image": "0675.jpg",
            "category": "category.default",
            "version": "1",
            "tags": {
                "sizedescription": "",
                "sizescale": "1.000",
                "sizewidth": "0.000",
                "sizewidtharc": "0",
                "sizeheight": "0.000",
                "sizeheightarc": "0",
                "sizedepth": "0.000",
                "sizedeptharc": "0",
                "sizeunits": ""
            }
        },
        "B06B954E-47F1-4830-AC6A-79D179C9CED1": {
            "index": 3,
            "name": "Packaging",
            "number": "0676",
            "image": "0676.jpg",
            "category": "category.default",
            "version": "1",
            "tags": {
                "sizedescription": "",
                "sizescale": "1.000",
                "sizewidth": "0.000",
                "sizewidtharc": "0",
                "sizeheight": "0.000",
                "sizeheightarc": "0",
                "sizedepth": "0.000",
                "sizedeptharc": "0",
                "sizeunits": ""
            }
        },
        "C882460B-2380-4C58-9225-CDB5D1ACEC7A": {
            "index": 4,
            "name": "Packaging",
            "number": "0685",
            "image": "0685.jpg",
            "category": "category.default",
            "version": "1",
            "tags": {
                "sizedescription": "",
                "sizescale": "0.000",
                "sizewidth": "71.600",
                "sizewidtharc": "0",
                "sizeheight": "97.400",
                "sizeheightarc": "0",
                "sizedepth": "0.000",
                "sizedeptharc": "0",
                "sizeunits": "mm"
            }
        },
        "FD617BF5-4700-478E-B066-3506CBAEF874": {
            "index": 5,
            "name": "Envelope",
            "number": "0723",
            "image": "0723.jpg",
            "category": "category.default",
            "version": "1",
            "tags": {
                "sizedescription": "A7",
                "sizescale": "0.000",
                "sizewidth": "7.250",
                "sizewidtharc": "0",
                "sizeheight": "5.250",
                "sizeheightarc": "0",
                "sizedepth": "0.000",
                "sizedeptharc": "0",
                "sizeunits": "in"
            }
        },
        "E4130A66-2605-4076-A6C9-91FE9F5F85EC": {
            "index": 6,
            "name": "Envelope",
            "number": "0724",
            "image": "0724.jpg",
            "category": "category.default",
            "version": "1",
            "tags": {
                "sizedescription": "A7",
                "sizescale": "0.000",
                "sizewidth": "7.250",
                "sizewidtharc": "0",
                "sizeheight": "5.250",
                "sizeheightarc": "0",
                "sizedepth": "0.000",
                "sizedeptharc": "0",
                "sizeunits": "in"
            }
        },
        "1DFCAB30-5EE2-47AA-8524-73BFCF09415D": {
            "index": 7,
            "name": "Book",
            "number": "0742",
            "image": "0742.jpg",
            "category": "category.default",
            "version": "1",
            "tags": {
                "sizedescription": "",
                "sizescale": "1.000",
                "sizewidth": "0.000",
                "sizewidtharc": "0",
                "sizeheight": "0.000",
                "sizeheightarc": "0",
                "sizedepth": "0.000",
                "sizedeptharc": "0",
                "sizeunits": ""
            }
        },
        "17B758FF-9E25-4BCA-A765-C006CD4EC925": {
            "index": 8,
            "name": "Clothing",
            "number": "0745",
            "image": "0745.jpg",
            "category": "category.default",
            "version": "1",
            "tags": {
                "sizedescription": "",
                "sizescale": "1.000",
                "sizewidth": "0.000",
                "sizewidtharc": "0",
                "sizeheight": "0.000",
                "sizeheightarc": "0",
                "sizedepth": "0.000",
                "sizedeptharc": "0",
                "sizeunits": ""
            }
        },
        "C4E6073D-4922-432A-888D-08AF3F12A331": {
            "index": 9,
            "name": "Newspaper",
            "number": "0747",
            "image": "0747.jpg",
            "category": "category.default",
            "version": "1",
            "tags": {
                "sizedescription": "",
                "sizescale": "1.000",
                "sizewidth": "0.000",
                "sizewidtharc": "0",
                "sizeheight": "0.000",
                "sizeheightarc": "0",
                "sizedepth": "0.000",
                "sizedeptharc": "0",
                "sizeunits": ""
            }
        }
    }
}
"""
            guard let data = apiResponse.data(using: String.Encoding.utf8) else {
                assertionFailure("could not serialize JSON string to data")
                return
            }
            
            do {
                if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any>,
                    let entityDescription = NSEntityDescription.entity(forEntityName: "ImageModel", in: self.managedObjectContext) {
                
                    // outer object is { "images": {} }
                    // each key is a UUID; each value is a child JSON dictionary
                    guard let imagesDictionary = jsonData["images"] as? Dictionary<String, Any> else {
                        //TODO: alert the user
                        preconditionFailure("unexpected JSON")
                    }
                    for (key, value) in imagesDictionary {
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
            catch {
                //TODO: alert user something has gone wrong
            }
        }
    }
    
}
