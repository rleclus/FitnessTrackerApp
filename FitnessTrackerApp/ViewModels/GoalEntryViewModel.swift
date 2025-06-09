//
//  GoalEntryViewModel.swift
//  FitnessTrackerApp
//
//  Created by Robert le Clus on 2025/06/07.
//
import Foundation
import SwiftData
import GoalManager

class GoalEntryViewModel: ObservableObject {
	@Published var errorMessage: String? = nil
	var context: ModelContext
	init(context: ModelContext) {
		self.context = context
	}

	private var goals: [Goal] = []
	
	func addGoal(day: String, stepGoal:Int) {
		let goal = Goal(id: UUID(), targetSteps: stepGoal, weekday: day, countedSteps: 0, durationInSeconds: 0)
		goals.append(goal)
	}
	
	func addGoalWeek(name: String, startDate: Date) throws {
		do {
			let service = GoalDataService(context: context)
			try service.addGoals(name: name, startDate: startDate, goals: goals)
			errorMessage = nil
		} catch {
			errorMessage = "Unable to save goals"
			throw error
		}
	}
}
