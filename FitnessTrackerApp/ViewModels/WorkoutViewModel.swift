//
//  WorkoutViewModel.swift
//  FitnessTrackerApp
//
//  Created by Robert le Clus on 2025/06/08.
//
import Foundation
import SwiftData
import WorkoutTracker
import GoalManager

class WorkoutViewModel: ObservableObject {
	private var context: ModelContext
	
	@Published var errorMessage: String? = nil
	
	init(context: ModelContext) {
		self.context = context
	}
	func startWorkout() {
		Task {
			await WorkoutManager.shared.startWorkout()
		}
	}
	
	func workoutComplete(duration: Int) {
		let workoutEndDate = Date()
		guard let weekStartDate = CalendarUtils.startOfCurrentWeek(from: workoutEndDate) else {
			errorMessage = "Could not get week start date"
			return
		}
		Task {
			let workout = await WorkoutManager.shared.stopWorkout()
			let stepCount = workout.stepCount
			let calories = workout.calories
			await MainActor.run {
				do {
					let weekDay = CalendarUtils.weekDay(for: workoutEndDate)
					let service = GoalDataService(context: context)
					var goal: Goal? = nil
					goal = try service.fetchGoal(startDate: weekStartDate, for: weekDay)
					if goal == nil {
						let formatter = DateFormatter()
						formatter.dateStyle = .medium
						formatter.timeStyle = .none
						let emptyWeek = "No Goal Week - \(formatter.string(from: weekStartDate))"
						if let startOfWeek = CalendarUtils.startOfCurrentWeek() {
							try service.saveEmptyWeek(with: emptyWeek, for: startOfWeek)
						} else {
							errorMessage = "Couldn't create empty week!"
							return
						}
						goal = try service.fetchGoal(startDate: weekStartDate, for: weekDay)
					}
					guard goal != nil else {
						errorMessage = "Unable to retrieve goal to assign workout to!"
						return
					}
					goal?.durationInSeconds += duration
					goal?.countedSteps += stepCount
					goal?.caloriesBurned += calories
					try service.saveContext()
				} catch {
					errorMessage = errorMessage?.description
				}
			}
		}
	}
	
}
