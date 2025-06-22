//
//  CoreDataEventListView.swift
//  CalendarEventApp
//
//  Created by C 4 U on 22/06/25.
//

import SwiftUI
import CoreData

// MARK: - CoreDataEventListView
struct CoreDataEventListView: View {
    @Environment(\.managedObjectContext) private var context
    var selectedDate: Date

    var startOfDay: Date {
        Calendar.current.startOfDay(for: selectedDate)
    }

    var endOfDay: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
    }

    @FetchRequest private var events: FetchedResults<EventEntity>

    init(selectedDate: Date) {
        self.selectedDate = selectedDate
        let request: NSFetchRequest<EventEntity> = EventEntity.fetchRequest()
        request.predicate = NSPredicate(format: Constants.Content.CalenderDateFormate, Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)! as NSDate, Calendar.current.startOfDay(for: selectedDate) as NSDate)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \EventEntity.date, ascending: true)]
        _events = FetchRequest(fetchRequest: request)
    }

    var grouped: [String: [EventEntity]] {
        Dictionary(grouping: events, by: { $0.type ?? Constants.Content.Other })
    }

    var body: some View {
        List {
            ForEach(grouped.keys.sorted(), id: \.self) { type in
                Section(header: Text(type).font(.headline)) {
                    ForEach(grouped[type] ?? []) { event in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(event.title ?? Constants.Content.NoTitle)
                                .font(.body)
                            if let note = event.notes {
                                Text(note)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            if let start = event.date, let end = event.endDate {
                                Text("\(start.formatted(date: .abbreviated, time: .shortened)) - \(end.formatted(date: .abbreviated, time: .shortened))")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                            if event.isRecurring {
                                Text(Constants.Content.Recurring)
                                    .font(.caption2)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}
