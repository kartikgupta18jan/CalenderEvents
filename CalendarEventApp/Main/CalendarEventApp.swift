//
//  CalendarEventApp.swift
//  CalendarEventApp
//
//  Created by C 4 U on 21/06/25.
//

import SwiftUI
import EventKit
import CoreData

@main
struct CalendarEventApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            CalendarMainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
