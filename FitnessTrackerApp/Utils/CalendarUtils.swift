//
//  CalendarUtils.swift
//  FitnessTrackerApp
//
//  Created by Robert le Clus on 2025/06/08.
//
import Foundation

class CalendarUtils {
	
	// Returns the start of the current week (Sunday by default)
	static func startOfCurrentWeek(from date: Date = Date()) -> Date? {
		var calendar = Calendar.current
		calendar.firstWeekday = 1

		let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
		return calendar.date(from: components)
	}

	// Returns the next 10 Sundays starting from this week’s Sunday
	static func next10Sundays(from date: Date = Date()) -> [Date] {
		guard let startOfWeek = startOfCurrentWeek(from: date) else {
			return []
		}

		var calendar = Calendar.current
		calendar.firstWeekday = 1

		var sundays: [Date] = []
		for i in 0..<10 {
			if let sunday = calendar.date(byAdding: .weekOfYear, value: i, to: startOfWeek) {
				sundays.append(sunday)
			}
		}

		return sundays
	}
	static func weekdayIndex(for dayName: String) -> Int {
		let calendar = Calendar.current
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "en_US_POSIX")
		formatter.dateFormat = "EEEE"
		formatter.calendar = calendar

		if let date = formatter.date(from: dayName) {
			return calendar.component(.weekday, from: date)
		}
		return 8
	}
	
	static func weekDay(for date:Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "EEEE"
		return dateFormatter.string(from: date)
	}
	
	static func formatTime(seconds: Int) -> String {
		let hours = seconds / 3600
		let minutes = (seconds % 3600) / 60
		let secs = seconds % 60
		return String(format: "%02d:%02d:%02d", hours, minutes, secs)
	}


}
