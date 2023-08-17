//
//  Family+CoreDataClass.swift
//  BashLearningCoreData
//
//  Created by Bash Xu on 2023/8/18.
//
//

import Foundation
import CoreData

@objc(Family)
public class Family: NSManagedObject {
    public var membersArray: [Person] {
        let set = members as? Set<Person> ?? []
        return set.sorted {
            $0.age < $1.age
        }
    }
    
    public var wrappedName: String {
        name ?? ""
    }
}
