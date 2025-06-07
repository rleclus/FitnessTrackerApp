//
//  FitnessTrackerAppApp.swift
//  FitnessTrackerApp
//
//  Created by Robert le Clus on 2025/06/04.
//

import SwiftUI
import GoalManager
import SwiftData

@main
struct FitnessTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
		}.modelContainer(for: [Goal.self, GoalWeek.self])
	}
}
