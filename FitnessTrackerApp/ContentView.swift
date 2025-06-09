//
//  ContentView.swift
//  FitnessTrackerApp
//
//  Created by Robert le Clus on 2025/06/04.
//

import SwiftUI
import WorkoutTracker

struct ContentView: View {
	@State var errorMessage: String? = nil
    var body: some View {
		TabView {
			Tab("Workout", image: "workout"){
				WorkoutView()
			}
			Tab("Goal", image: "goal") {
				GoalView()
			}
 		}
		.onAppear() {
			Task {
				do {
					try await WorkoutManager.shared.authoriseHealthKit()
				} catch {
					errorMessage = "Nessage"
				}
			}
		}
     }
}

#Preview {
    ContentView()
}

