//
//  EventKitManager.swift
//  CalendarEventApp
//
//  Created by C 4 U on 21/06/25.
//

import Foundation
import EventKit
import CoreData

class EventKitManager {
    let eventStore = EKEventStore()

    func requestAccess(completion: @escaping (Bool) -> Void) {
        eventStore.requestAccess(to: .event) { granted, _ in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    func fetchEvents(startDate: Date, endDate: Date) -> [EKEvent] {
        let calendars = eventStore.calendars(for: .event)
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)
        return eventStore.events(matching: predicate)
    }

    func importEventsIntoCoreData(context: NSManagedObjectContext) {
        let start = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        let end = Calendar.current.date(byAdding: .day, value: 30, to: Date())!
        let calendars = eventStore.calendars(for: .event).filter { $0.allowsContentModifications }

        let predicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: calendars)
        let ekEvents = eventStore.events(matching: predicate)

        for ekEvent in ekEvents {
            let newEvent = EventEntity(context: context)
            newEvent.id = UUID()
            newEvent.title = ekEvent.title
            newEvent.date = ekEvent.startDate
            newEvent.endDate = ekEvent.endDate
            newEvent.notes = ekEvent.notes
            newEvent.type = Constants.Content.Calendar
            newEvent.isRecurring = ekEvent.hasRecurrenceRules
        }

        do {
            try context.save()
            print("\(Constants.Content.EventSaveSuccessMessage)")
        } catch {
            print("\(Constants.Content.EventSaveFailiurMessage): \(error)")
        }
    }
}
