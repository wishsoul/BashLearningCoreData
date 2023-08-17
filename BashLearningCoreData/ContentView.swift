//
//  ContentView.swift
//  BashLearningCoreData
//
//  Created by Bash Xu on 2023/8/17.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Family.id, ascending: true)], predicate: nil, animation: .default)
    private var families: FetchedResults<Family>

    var body: some View {
        NavigationView {
            List {
                ForEach(families) { family in
                    NavigationLink {
                        List {
                            ForEach(family.membersArray, id:\.self) { person in
                                Text("\(person.wrappedFirstName) \(person.wrappedFamilyName), \(person.wrappedGender), \(person.age)")
                            }
                            
                        }
                        .navigationTitle(Text("🏠 \(family.wrappedName)"))
                        
                    } label: {
                        Text("\(family.name!) count: \(family.members?.count ?? 0)")
                    }
                    .navigationTitle("Family")
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            PersistenceController.newFamily(viewContext: viewContext)
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { families[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
