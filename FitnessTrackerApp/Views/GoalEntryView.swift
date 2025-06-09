//
//  GoalEntryView.swift
//  FitnessTrackerApp
//
//  Created by Robert le Clus on 2025/06/06.
//
import SwiftUI
import GoalManager

struct GoalEntryView: View {
	private var workoutWeek = Week.generateWeekArray()
	private var dates: [Date] {
		CalendarUtils.next10Sundays(from: Date())
	}
	@State var currentDay = 0
	@State var currentStepGoal: String = "10000"
	@State var goalName: String = ""
	@State var startDate: Date? = nil
	@State var viewModel: GoalEntryViewModel? = nil
	@State var showError = false
	@State  var localError = ""
	@Environment(\.modelContext) private var context
	@Environment(\.dismiss) private var dismiss
	
	var body: some View {
		NavigationStack {
			if showError {
				Spacer()
				GeometryReader { geometry in
					Text(viewModel?.errorMessage ?? localError)
						.foregroundColor(.white)
						.padding()
						.frame(width: geometry.size.width)
						.background(Color.red)
				}
				.frame(height: 50)
			}
			Form {
				LabeledContent {
					TextField("", text: $goalName)
						.multilineTextAlignment(.trailing)
						.disabled(currentDay != 0)
				} label: {
					Text("Goal Name:").font(.headline).bold()
				}
				LabeledContent {
					Picker("", selection: $startDate) {
						ForEach(dates, id: \.self) { date in
							Text(formatDate(date: date)).tag(date)
						}
					}
					.disabled(currentDay != 0)
				} label: {
					Text("Start Date:").font(.headline).bold()
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
						if startDate == nil {
							localError = "Select a start date"
							showError = true
							return
						}
						showError = false
						if currentDay < workoutWeek.count - 1 {
							viewModel?.addGoal(day: workoutWeek[currentDay].rawValue, stepGoal: Int(currentStepGoal) ?? 0)
							currentDay += 1
						} else {
							do {
								try viewModel?.addGoalWeek(name: goalName, startDate: startDate ?? Date())
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
	func formatDate(date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateStyle = .long
		let string = formatter.string(from: date)
		return string
	}
}

#Preview {
	GoalEntryView()
}
