//
//  StringToUuidDataTransformer.swift
//  LiveSurfaceImageEditor
//
//  Created by Jason Cross on 2020-05-16.
//  Copyright © 2020 Jason Cross. All rights reserved.
//

import Foundation

public class StringToUuidDataTransformer: ValueTransformer {
    
    override public class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override open class func transformedValueClass() -> AnyClass {
        return NSUUID.self
    }
    
    /**
     Converts a String into NSUUID
     
     - parameters:
     - value: The String to be converted
     
     - returns:
         - the NSUUID  (after conversion)
     */
    override public func transformedValue(_ value: Any?) -> Any? {
        guard let stringValue = value as? String else {
            return nil
        }
        
        let uuid = NSUUID(uuidString: stringValue)
        return uuid
    }
    
    /**
     Converts NSUUID into a String
     
     - parameters:
     - value: The NSUUID  to be converted
     
     - returns:
     - the String (after conversion)
     */
    override public func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let uuid = value as? NSUUID else {
            return nil
        }
        
        let stringValue = uuid.uuidString
        return stringValue
    }
}
