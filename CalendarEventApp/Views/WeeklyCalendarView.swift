//
//  WeeklyCalendarView.swift
//  CalendarEventApp
//
//  Created by C 4 U on 22/06/25.
//

import SwiftUI

// MARK: - WeeklyCalendarView
struct WeeklyCalendarView: View {
    @ObservedObject var viewModel: CalendarViewModel

    private let columns = Array(repeating: GridItem(.flexible()), count: 7)

    var body: some View {
        let weekDates = generateDatesForWeek(containing: viewModel.selectedDate)

        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(weekDates, id: \.self) { date in
                VStack(spacing: 4) {
                    Text("\(Calendar.current.shortWeekdaySymbols[Calendar.current.component(.weekday, from: date) - 1])")
                        .font(.caption2)
                        .foregroundColor(.secondary)

                    Text("\(Calendar.current.component(.day, from: date))")
                        .font(.subheadline.bold())
                        .frame(width: 32, height: 32)
                        .background(Calendar.current.isDateInToday(date) ? Color.blue : Color.clear)
                        .foregroundColor(Calendar.current.isDateInToday(date) ? .white : .primary)
                        .clipShape(Circle())

                    Text("\(viewModel.eventCount(for: date))")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                .padding(4)
                .background(Calendar.current.isDate(viewModel.selectedDate, inSameDayAs: date) ? Color.blue.opacity(0.2) : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .onTapGesture {
                    viewModel.selectedDate = date
                }
            }
        }
    }

    func generateDatesForWeek(containing date: Date) -> [Date] {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let start = calendar.date(byAdding: .day, value: -(weekday - 1), to: date) ?? date
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: start) }
    }
}
