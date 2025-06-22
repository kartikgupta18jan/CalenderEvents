//
//  CalenderEvents.swift
//  CalendarEventApp
//
//  Created by C 4 U on 21/06/25.
//

import Foundation

enum EventType: String, CaseIterable, Identifiable {
    case task, meeting, calendarEvent, birthday, leave, other
    var id: String { self.rawValue }
}

struct CalendarEvent: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    let type: EventType
}
