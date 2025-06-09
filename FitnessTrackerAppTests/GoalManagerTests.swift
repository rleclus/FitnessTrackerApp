//
//  GoalManagerTests.swift
//  FitnessTrackerAppTests
//
//  Created by Robert le Clus on 2025/06/09.
//

import Testing
import SwiftData
import Foundation
@testable import FitnessTrackerApp
@testable import GoalManager

struct GoalManagerTests {

	func makeDate(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
		var components = DateComponents()
		components.year = year
		components.month = month
		components.day = day
		components.hour = hour
		components.minute = minute

		let futureDate = Calendar.current.date(from: components)
		return futureDate ?? Date()
	}
	func makeInMemoryModelContainer(for modelTypes: [any PersistentModel.Type]) throws -> ModelContainer {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		let schema = Schema(modelTypes)
		return try ModelContainer(for: schema, configurations: config)
	}
	
    @Test func testGoalDataService_makeGoals() async throws {
		let container = try makeInMemoryModelContainer(for: [Goal.self, GoalWeek.self])
		let context = ModelContext(container)

		let service = GoalDataService(context: context)
		var goals = service.makeGoals(from: [(0, 0, 0, "Sunday")])

		#expect(goals.count == 1)
		
		goals = service.makeGoals(from: [(0, 0, 0, "Sunday"),
										(1,1,1,"Tuesday"),
										(2,2,2, "Wednessday")])
		#expect(goals.count == 3)
    }
	@Test func testGoalDataService_saveEmptyWeek() async throws {
		let container = try makeInMemoryModelContainer(for: [Goal.self, GoalWeek.self])
		let context = ModelContext(container)

		let service = GoalDataService(context: context)
		let date = CalendarUtils.startOfCurrentWeek(from: Date()) ?? Date()
		try service.saveEmptyWeek(with: "Test name", for: date)
		let goalsWeeks = try service.fetchGoals()
		#expect(goalsWeeks.count == 1)
		#expect(goalsWeeks[0].goalsForWeek.count == 7)
		#expect(goalsWeeks[0].goalsForWeek.allSatisfy { $0.targetSteps == 0 })
		#expect(goalsWeeks[0].goalsForWeek.allSatisfy { $0.countedSteps == 0 })
		#expect(goalsWeeks[0].goalsForWeek.allSatisfy { $0.durationInSeconds == 0 })
		let allWeekdays: Set<String> = [
			"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
		]
		let weekdaysInItems = Set(goalsWeeks[0].goalsForWeek.map { $0.weekday })
		#expect(weekdaysInItems == allWeekdays)
		#expect(goalsWeeks[0].goalName == "Test name")
	}
	@Test func testGoalDataService_addGoals() async throws {
		let container = try makeInMemoryModelContainer(for: [Goal.self, GoalWeek.self])
		let context = ModelContext(container)

		let service = GoalDataService(context: context)
		let date = CalendarUtils.startOfCurrentWeek(from: Date()) ?? Date()
		let goals = service.makeGoals(from: [(0, 0, 0, "Sunday"),
										(1,1,1,"Tuesday"),
										(2,2,2, "Wednessday")])

		try service.addGoals(name: "Test name 2", startDate: date, goals: goals)
		
		let goalsWeeks = try service.fetchGoals()
		#expect(goalsWeeks.count == 1)
		#expect(goalsWeeks[0].goalsForWeek.count == 3)
	}
	
	@Test func testGoalDataService_fetchGoal() async throws {
		let container = try makeInMemoryModelContainer(for: [Goal.self, GoalWeek.self])
		let context = ModelContext(container)

		let service = GoalDataService(context: context)
		let goals1 = service.makeGoals(from: [(0, 0, 0, "Sunday"),
										(1,1,1,"Tuesday"),
										(2,2,2, "Wednessday")])
		let goals2 = service.makeGoals(from: [(4, 4, 4, "Thursday"),
										(5,5,5,"Friday"),
										(6,6,6, "Saturday")])
		let date1 = makeDate(year: 2025, month: 12, day: 4, hour: 15, minute: 22)
		let startDate1 = CalendarUtils.startOfCurrentWeek(from: date1) ?? Date()
		try service.addGoals(name: "Test name 3", startDate: startDate1, goals: goals1)
		let date2 = makeDate(year: 2026, month: 12, day: 4, hour: 15, minute: 22)
		let startDate2 = CalendarUtils.startOfCurrentWeek(from: date2) ?? Date()
		try service.addGoals(name: "Test name 4", startDate: startDate2, goals: goals2)
		
		let result = try service.fetchGoal(startDate: Date(), for: "Wednesday")
		#expect(result == nil)
		let result2 = try service.fetchGoal(startDate: startDate1, for: "Monday")
		#expect(result2 == nil)
		let result3 = try service.fetchGoal(startDate: startDate1, for: "Tuesday")
		#expect(result3 != nil)
		let result4 = try service.fetchGoal(startDate: startDate2, for: "Tuesday")
		#expect(result4 == nil)
		let result5 = try service.fetchGoal(startDate: startDate2, for: "Saturday")
		#expect(result5 != nil)
	}
}
