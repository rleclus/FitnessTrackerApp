//
//  GoalWeekDetail.swift
//  FitnessTrackerApp
//
//  Created by Robert le Clus on 2025/06/06.
//
import SwiftUI
import GoalManager

struct GoalWeekDetailView: View {
	let weekDayNumbers = [
		"Sunday": 0,
		"Monday": 1,
		"Tuesday": 2,
		"Wednesday": 3,
		"Thursday": 4,
		"Friday": 5,
		"Saturday": 6,
	]
	let goalWeek: GoalWeek
	var sortedWeek: [Goal] {
		return goalWeek.goalsForWeek.sorted(by: { (weekDayNumbers[$0.weekday] ?? 7) < (weekDayNumbers[$1.weekday] ?? 7) })
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
						Text("\(goal.durationInMinutes)")
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
	let goals = [Goal(targetSteps: 10000, countedSteps: 5321, durationInMinutes: 5, weekday: "Sunday", id: UUID()),
				 Goal(targetSteps: 10000, countedSteps: 5321, durationInMinutes: 10, weekday: "Monday", id: UUID()),
				 Goal(targetSteps: 10000, countedSteps: 5321, durationInMinutes: 20, weekday: "Tuesday", id: UUID())]
	let goalWeek = GoalWeek(id: UUID(), goalName: "Week1", goalsForWeek: goals)
	GoalWeekDetailView(goalWeek: goalWeek)
}
