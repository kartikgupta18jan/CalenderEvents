//
//  CalendarViewModel.swift
//  CalendarEventApp
//
//  Created by C 4 U on 21/06/25.
//

import SwiftUI
import CoreData

class CalendarViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
    @Published var isLoading: Bool = true
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context

        if !UserDefaults.standard.bool(forKey: Constants.Content.UserDefaultPreloadKey) {
            self.isLoading = true
            preloadEvents()
            UserDefaults.standard.set(true, forKey: Constants.Content.UserDefaultPreloadKey)
        } else {
            isLoading = false
        }
    }

    func preloadEvents() {
        let calendar = Calendar.current
        let now = Date()

        for i in 0..<500 {
            let entity = EventEntity(context: context)
            entity.id = UUID()
            entity.title = "Sample Event \(i)"
            entity.notes = "Notes for event \(i)"
            entity.type = ["Task", "Meeting", "Birthday", "Leave", "Other"].randomElement()!
            entity.date = calendar.date(byAdding: .day, value: Int.random(in: -90...90), to: now)
            entity.endDate = Calendar.current.date(byAdding: .hour, value: Int.random(in: 1...72), to: entity.date!)
            entity.isRecurring = Bool.random()
        }

        do {
            try self.context.save()
        } catch {
            print("Failed to save preloaded events: \(error)")
        }

        DispatchQueue.main.async {
            self.isLoading = false
        }
    }

    func eventCount(for date: Date) -> Int {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        let request: NSFetchRequest<EventEntity> = EventEntity.fetchRequest()
        request.predicate = NSPredicate(format: Constants.Content.CalenderDateFormate, endOfDay as NSDate, startOfDay as NSDate)
        return (try? context.count(for: request)) ?? 0
    }
}
