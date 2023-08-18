//
//  BashLearningCoreDataTests.swift
//  BashLearningCoreDataTests
//
//  Created by Bash Xu on 2023/8/17.
//

import XCTest
import CoreData
import Foundation

@testable import BashLearningCoreData

final class BashLearningCoreDataTests: XCTestCase {

    var persisetenceController: PersistenceController!
    var viewContext: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        
        persisetenceController = PersistenceController.unitTest
        viewContext = persisetenceController.container.viewContext
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
        
        persisetenceController = nil
        
    }
    
    // MARK: Create
    
    func testFamilyAdd() throws {

        let family = PersistenceController.addFamily(id: UUID(), name: "Bash", address: "Aloha Road", members: nil, viewContext: viewContext)
        persisetenceController.save()

        let request = NSFetchRequest<Family>.init(entityName: Family.className)
        let families = try! self.viewContext.fetch(request)

        guard let savedFamily = families.first else {
            XCTFail("color missing")
            return
        }

        XCTAssertNotNil(savedFamily.id, "id should not be nil")
        XCTAssertEqual(savedFamily.name, "Bash")
        XCTAssertEqual(savedFamily.address, "Aloha Road")
    }

    func testFamilyUpdate() throws {
        let family = PersistenceController.addFamily(id: UUID(), name: "Bash", address: "Aloha Road", members: nil, viewContext: viewContext)
        persisetenceController.save()

        let request = NSFetchRequest<Family>.init(entityName: Family.className)
        let families = try! self.viewContext.fetch(request)

        guard let savedFamily = families.first else {
            XCTFail("family missing")
            return
        }

        savedFamily.address = "Hello Road"
        persisetenceController.save()

        let newRequest = NSFetchRequest<Family>.init(entityName: Family.className)
        let newFamilies = try! self.viewContext.fetch(request)

        guard let newSavedFamily = newFamilies.first else {
            XCTFail("family missing")
            return
        }
        XCTAssertEqual(newSavedFamily.address, "Hello Road")

    }
    
    func testFamilyDelete() throws {
        
        let family = PersistenceController.addFamily(id: UUID(), name: "Bash", address: "Aloha Road222", members: nil, viewContext: viewContext)
        persisetenceController.save()
        
        let request = NSFetchRequest<Family>.init(entityName: Family.className)
        let families = try! self.viewContext.fetch(request)
        
        guard let savedFamily = families.first else {
            XCTFail("family missing")
            return
        }
        
        self.viewContext.delete(savedFamily)
        
        let exp = expectation(description: "save family")
        persisetenceController.save(expectation: exp)

        waitForExpectations(timeout: 1)
    
        let newRequest = NSFetchRequest<Family>.init(entityName: Family.className)
    
        let newFamilies = try! self.viewContext.fetch(request)
        XCTAssertNil(newFamilies.first)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            
        }
    }

}
