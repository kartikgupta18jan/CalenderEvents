# CalenderEvents
# SwiftUI Calendar App with CoreData & EventKit

A fully functional calendar application built using **SwiftUI**, **CoreData**, and **EventKit** that supports weekly/monthly views, date-wise event counts, iOS Calendar integration, and real-time UI updates.

---

## Features

- **Weekly & Monthly Calendar Views**
- **Date-wise Event Counts**
- **Event Types**: Tasks, Meetings, Birthdays, Leaves, Calendar Events, and more
- **Auto-updating UI** using CoreData and `@FetchRequest`
- **Integration with iOS System Calendar** via `EventKit`
- **Multi-day and Recurring Event Support**
- **Auto-Sync from System Calendar every 5 minutes**
- **500+ preloaded events** to test performance
- **Loading spinner** during sync operations

---

## Architecture

- `CoreData`: Stores all event data locally.
- `EventKit`: Imports events from iOS Calendar.
- `SwiftUI`: Declarative UI with MVVM pattern.
- `@FetchRequest`: Real-time updates from CoreData.

---

## Permissions

Ensure the following permission is added in `Info.plist`:
```xml
<key>NSCalendarsUsageDescription</key>
<string>This app requires access to your calendar to import events.</string>
