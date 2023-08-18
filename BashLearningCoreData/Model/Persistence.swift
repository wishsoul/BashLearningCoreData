//
//  Persistence.swift
//  BashLearningCoreData
//
//  Created by Bash Xu on 2023/8/17.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "BashLearningCoreData")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    public func save() {
        do {
            try container.viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

extension PersistenceController {
     public static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            addNewFamilyWithRandomMembers(viewContext: viewContext)
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    @discardableResult
    public static func newPerson(viewContext:NSManagedObjectContext, familyName:String) -> Person {
        let newPerson = Person(context: viewContext)
        newPerson.id = UUID()
        newPerson.lastName = randomPersonLastName()
        newPerson.firstName = familyName
        newPerson.age = Int64.random(in: 1...99)
        newPerson.birthdate = Date()
        newPerson.gender = ["male", "female"].randomElement()!
        return newPerson
    }
    
    @discardableResult
    static func addNewFamilyWithRandomMembers(viewContext: NSManagedObjectContext) -> Family {
        let newFamily = Family(context: viewContext)
        newFamily.id = UUID()
        let familyName = randomFamilyName()
        newFamily.name = familyName
        
        let randomMembers = Int.random(in: 0...8)
        
        for _ in 0...randomMembers {
            let person = newPerson(viewContext: viewContext, familyName:familyName)
            newFamily.addToMembers(person)
        }
        
        return newFamily
    }
    
    @discardableResult
    static func addFamily(id: UUID?, name: String?,
                          address: String?, members:[Person]?, viewContext: NSManagedObjectContext) -> Family {
        let newFamily = Family(context: viewContext)
        newFamily.id = id
        newFamily.name = name
        newFamily.address = address
        if let members = members {
            for person in members {
                newFamily.addToMembers(person)
            }
        }
        return newFamily
    }
    
    @discardableResult
    static func deleteFamily(family: Family,
                             viewContext: NSManagedObjectContext) -> Family {
        viewContext.delete(family)
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return family
    }
    
    @discardableResult
    static func addPerson(id: UUID?, firstName: String?, lastName: String?,
                          birthDate: Date?, gender: String?, family: Family?,
                          contextView: NSManagedObjectContext) -> Person {
        let person = Person(context: contextView)
        person.id = id
        person.firstName = firstName
        person.lastName = lastName
        person.birthdate = birthDate
        person.gender = gender
        person.family = family
        
        return person
    }
    
    static func randomPersonLastName() -> String {
        return ["Emma","Olivia","Ava","Isabella","Sophia","Mia","Charlotte","Amelia","Evelyn",
         "Harper","Emily","Abigail","Ella","Lily","Layla","Hannah","Elizabeth","Aaliyah","Zoey"]
        .randomElement()!
    }
    
    static func randomFamilyName() -> String {
    return["Mike","Nick","John","James","Robert","William","David","Charles","Thomas","Michael","Paul","George","Richard","Joseph","Daniel","Christopher","Anthony","Edward","Steven","Andrew"]
            .randomElement()!
    }
}

extension PersistenceController {
    static var unitTest: PersistenceController = {
        return PersistenceController(inMemory: true)
    }()
}
