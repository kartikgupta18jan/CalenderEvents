//
//  ContentView.swift
//  CalendarEventApp
//
//  Created by C 4 U on 21/06/25.
//
import Foundation
import SwiftUI
import CoreData
import Combine
import EventKit

struct CalendarMainView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject private var viewModel = CalendarViewModel(
        context: PersistenceController.shared.container.viewContext
    )
    @State private var showMonthly = true
    @State private var isSyncing: Bool = false
    let eventKitManager = EventKitManager()

    // Auto-sync timer every 5 minutes
    let syncTimer = Timer.publish(every: 300, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 16) {
            Picker("View", selection: $showMonthly) {
                Text("Monthly").tag(true)
                Text("Weekly").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            if isSyncing {
                ProgressView(Constants.Content.SyncingCalender)
                    .padding(.bottom, 8)
            }
            Button(action: {
                eventKitManager.requestAccess { granted in
                    if granted {
                        isSyncing = true
                        DispatchQueue.global(qos: .background).async {
                            eventKitManager.importEventsIntoCoreData(context: context)
                            DispatchQueue.main.async {
                                isSyncing = false
                            }
                        }
                    }
                }
            }) {
                Label(Constants.Content.ImportCalender, systemImage: Constants.Design.Image.CalenderImage)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            Text("\(viewModel.selectedDate.formatted(date: .abbreviated, time: .omitted))")
                .font(.title2.bold())
                .padding(.top, 8)

            if showMonthly {
                MonthlyCalendarView(viewModel: viewModel).padding(.horizontal)
            } else {
                WeeklyCalendarView(viewModel: viewModel).padding(.horizontal)
            }

            CoreDataEventListView(selectedDate: viewModel.selectedDate)
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .onReceive(syncTimer) { _ in
            let status = EKEventStore.authorizationStatus(for: .event)
            if status == .authorized {
                isSyncing = true
                print(Constants.Content.AutoSync)
                DispatchQueue.global(qos: .background).async {
                    eventKitManager.importEventsIntoCoreData(context: context)
                    DispatchQueue.main.async {
                        isSyncing = false
                    }
                }
            } else {
                print(Constants.Content.SkippedSyncMessage)
            }
        }
    }
}
