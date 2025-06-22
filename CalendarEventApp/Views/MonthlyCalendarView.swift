//
//  MonthlyCalendarView.swift
//  CalendarEventApp
//
//  Created by C 4 U on 22/06/25.
//

import SwiftUI

// MARK: - MonthlyCalendarView
struct MonthlyCalendarView: View {
    @ObservedObject var viewModel: CalendarViewModel

    private let columns = Array(repeating: GridItem(.flexible()), count: 7)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(generateDatesForMonth(), id: \.self) { date in
                VStack(spacing: 4) {
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

    func generateDatesForMonth() -> [Date] {
        let calendar = Calendar.current
        let today = Date()
        guard let range = calendar.range(of: .day, in: .month, for: today),
              let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today)) else {
            return []
        }

        return range.compactMap { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth)
        }
    }
}
