//
//  Person+CoreDataClass.swift
//  BashLearningCoreData
//
//  Created by Bash Xu on 2023/8/17.
//
//

import Foundation
import CoreData

@objc(Person)
public class Person: NSManagedObject {

    public var wrappedFirstName: String {
        firstName ?? ""
    }
    
    public var wrappedFamilyName: String {
        lastName ?? ""
    }
    
    public var wrappedGender: String {
        gender ?? "unkown"
    }
}
