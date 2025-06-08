//
//  GoalView.swift
//  FitnessTrackerApp
//
//  Created by Robert le Clus on 2025/06/06.
//
import SwiftUI
import GoalManager
import SwiftData

public struct GoalView: View {
	@Query var goalWeeks: [GoalWeek]  
	@State var viewModel: GoalViewModel? = nil
	@Environment(\.modelContext) private var context
	@State var isShowingGoalEntryView = false
	init() {
	}
	public var body: some View {
		NavigationStack {
			List(goalWeeks) { week in
				NavigationLink {
					GoalWeekDetailView(goalWeek: week)
				} label: {
					Text(week.goalName)
				}
			}.toolbar {
				ToolbarItem(placement: .principal) {
					Text("Goals")
						.font(.title)
						.bold()
						.padding()
				}
				ToolbarItem(placement: .topBarTrailing) {
					Button(action:  {
						isShowingGoalEntryView = true
					}) {
						Image(systemName: "plus")
					}.navigationDestination(isPresented: $isShowingGoalEntryView) {
						GoalEntryView()
					}
				}
			}
			
		}.onAppear(){
			viewModel = GoalViewModel(context: context)
		}
	}
}

#Preview {
	GoalView()
}
