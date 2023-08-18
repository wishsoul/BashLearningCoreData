//
//  TestHelper.swift
//  BashLearningCoreDataTests
//
//  Created by xugh22 on 2023/8/18.
//

import Foundation
import XCTest
@testable import BashLearningCoreData

extension PersistenceController {
    
    public func save(expectation: XCTestExpectation) {
        do {
            try container.viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        expectation.fulfill()
    }
}
