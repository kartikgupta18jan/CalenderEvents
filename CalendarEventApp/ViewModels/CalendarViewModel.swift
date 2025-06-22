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
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context

        if !UserDefaults.standard.bool(forKey: Constants.Content.UserDefaultPreloadKey) {
            preloadEvents()
            UserDefaults.standard.set(true, forKey: Constants.Content.UserDefaultPreloadKey)
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

        try? context.save()
    }

    func eventCount(for date: Date) -> Int {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        let request: NSFetchRequest<EventEntity> = EventEntity.fetchRequest()
        request.predicate = NSPredicate(format: Constants.Content.CalenderDateFormate, endOfDay as NSDate, startOfDay as NSDate)
        return (try? context.count(for: request)) ?? 0
    }
}
