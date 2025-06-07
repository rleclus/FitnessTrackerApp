//
//  ContentView.swift
//  FitnessTrackerApp
//
//  Created by Robert le Clus on 2025/06/04.
//

import SwiftUI
import WorkoutTracker

struct ContentView: View {
    var body: some View {
		TabView {
			Tab("Workout", image: "workout"){
				WorkoutView()
			}
			Tab("Goal", image: "goal") {
				GoalView()
			}
 		}
    }
}

#Preview {
    ContentView()
}

