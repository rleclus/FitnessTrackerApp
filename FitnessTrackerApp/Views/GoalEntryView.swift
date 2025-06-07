//
//  GoalEntryView.swift
//  FitnessTrackerApp
//
//  Created by Robert le Clus on 2025/06/06.
//
import SwiftUI


struct GoalEntryView: View {
	private var workoutWeek = [Week.Sunday, Week.Monday, Week.Tuesday, Week.Wednesday, Week.Thursday, Week.Friday, Week.Saturday]
	@State var currentDay = 0
	@State var currentStepGoal: String = "10000"
	@State var goalName: String = ""
	@State var viewModel: GoalEntryViewModel? = nil
	@State var showError = false
	@State var localError = ""
	@Environment(\.modelContext) private var context
	@Environment(\.dismiss) private var dismiss

	var body: some View {
		if showError {
			Text(viewModel?.errorMessage ?? localError)
		}
		NavigationStack {
				Form {
					LabeledContent {
						TextField("", text: $goalName).multilineTextAlignment(.trailing)
					} label: {
						Text("Goal Name:").font(.headline).bold()
					}
					LabeledContent {
						Text(workoutWeek[currentDay].rawValue)
					} label: {
						Text("Day:").font(.headline).bold()
					}
					LabeledContent {
						TextField("", text: $currentStepGoal).multilineTextAlignment(.trailing)
					} label: {
						Text("Step Goal:").font(.headline).bold()
					}
				}
			.toolbar {
				ToolbarItem(placement: .principal) {
					Text("Workout Entry")
						.font(.title)
						.bold()
						.padding()
				}
				ToolbarItem(placement: .topBarTrailing) {
					Button(action:  {
						if goalName.isEmpty {
							localError = "Goal name is empty"
							showError = true
							return
						}
						showError = false
						if currentDay < workoutWeek.count - 1 {
							viewModel?.addGoal(day: workoutWeek[currentDay].rawValue, stepGoal: Int(currentStepGoal) ?? 0)
							currentDay += 1
						} else {
							do {
								try viewModel?.addGoalWeek(name: goalName)
								dismiss()
							} catch {
								showError = true
							}
						}
					}) {
						if currentDay == workoutWeek.count - 1 {
							Text("Done")
						} else {
							Text("Next")
						}
					}
				}
				
			}
		}.onAppear(){
			viewModel = GoalEntryViewModel(context: context)
		}
		
	}
}

#Preview {
	GoalEntryView()
}
