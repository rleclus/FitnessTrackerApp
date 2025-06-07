//
//  GoalViewModel.swift
//  FitnessTrackerApp
//
//  Created by Robert le Clus on 2025/06/06.
//
import SwiftUI
import GoalManager
import SwiftData

final class GoalViewModel: ObservableObject {
	var context: ModelContext
	init(context: ModelContext) {
		self.context = context
	}
}
