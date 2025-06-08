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
}
