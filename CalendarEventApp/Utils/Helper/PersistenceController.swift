//
//  PersistenceController.swift
//  CalendarEventApp
//
//  Created by C 4 U on 21/06/25.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: Constants.Content.CoreDatabaseModel)
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: Constants.API.PersistenceMemoryURL)
        }
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("\(Constants.Content.UnresolvedErrorMessage) \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
