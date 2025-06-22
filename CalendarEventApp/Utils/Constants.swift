//
//  Constants.swift
//  CalendarEventApp
//
//  Created by C 4 U on 22/06/25.
//

import Foundation
import SwiftUI

struct Constants {
    struct Design {
        struct Color {
            // Colors
        }
        struct Image {
            static let CalenderImage = "calendar.badge.plus"
        }
    }
    
    struct Content {
        static let Calendar = "Calendar"
        static let CoreDatabaseModel = "CalendarModel"
        static let CalenderDateFormate = "(date <= %@ AND endDate >= %@)"
        static let UserDefaultPreloadKey = "didPreload"
        static let Other = "Other"
        static let NoTitle = "No Title"
        static let Recurring = "↻ Recurring"
        
        static let EventSaveSuccessMessage = "Successfully saved events to CoreData"
        static let EventSaveFailiurMessage = "Failed to save events"
        static let UnresolvedErrorMessage = "Unresolved error:"
        static let SkippedSyncMessage = "Skipped sync: permission denied"
        static let AutoSync = "Auto-syncing..."
        static let ImportCalender = "Import from iOS Calendar"
        static let SyncingCalender = "Syncing calendar..."
    }
    struct API {
        static let PersistenceMemoryURL = "/dev/null"
    }
}
