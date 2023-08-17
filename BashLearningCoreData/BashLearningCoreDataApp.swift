//
//  BashLearningCoreDataApp.swift
//  BashLearningCoreData
//
//  Created by Bash Xu on 2023/8/17.
//

import SwiftUI

@main
struct BashLearningCoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
