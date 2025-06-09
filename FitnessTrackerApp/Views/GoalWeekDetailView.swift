//
//  GoalWeekDetail.swift
//  FitnessTrackerApp
//
//  Created by Robert le Clus on 2025/06/06.
//
import SwiftUI
import GoalManager

struct GoalWeekDetailView: View {
	let goalWeek: GoalWeek
	var sortedWeek: [Goal] {
		goalWeek.goalsForWeek.sorted {
			let day1 = CalendarUtils.weekdayIndex(for: $0.weekday)
			let day2 = CalendarUtils.weekdayIndex(for: $1.weekday)
			return day1 < day2
		}
	}
	var body: some View {
		VStack {
			Grid {
				GridRow {
					Text("Day").bold().font(.headline)
					Text("Target").bold().font(.headline)
					Text("Step Count").bold().font(.headline)
					Text("Duration").bold().font(.headline)
					
				}
				Divider()
				ForEach(sortedWeek, id: \.id) { goal in
					GridRow {
						Text(goal.weekday)
						Text("\(goal.targetSteps)")
						Text("\(goal.countedSteps)")
						Text("\(CalendarUtils.formatTime(seconds: goal.durationInSeconds))")
					}
					Divider()
				}
			}
			Spacer()
		}.toolbar {
			ToolbarItem(placement: .principal) {
				Text("Week")
					.font(.title)
					.bold()
					.padding()
			}
		}
	}
}
#Preview {
	let goals = [Goal(id: UUID(), targetSteps: 10000, weekday: "Sunday", countedSteps: 5321, durationInSeconds: 5*60),
				 Goal(id: UUID(), targetSteps: 10000, weekday: "Monday", countedSteps: 5321, durationInSeconds: 10*60),
				 Goal(id: UUID(), targetSteps: 10000, weekday: "Tuesday", countedSteps: 5321, durationInSeconds: 20*60)]
	let goalWeek = GoalWeek(id: UUID(), goalName: "Week1", startDate: Date(), goalsForWeek: goals)
	GoalWeekDetailView(goalWeek: goalWeek)
}
