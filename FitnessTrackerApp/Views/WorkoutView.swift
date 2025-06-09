//
//  WorkoutView.swift
//  WorkoutTracker
//
//  Created by Robert le Clus on 2025/06/04.
//
import SwiftUI
import SwiftData

public struct WorkoutView: View {
	@State var isAnimated = false
	@State var workoutTimer = "00:00:00"
	@State private var elapsedSeconds = 0
	@State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	@Environment(\.modelContext) private var context
	@State var viewModel: WorkoutViewModel? = nil
	public var body: some View {
		VStack {
			Text("Workout").font(.largeTitle)
			RunningManImageView(isAnimated: $isAnimated)
			Text(workoutTimer)
				.font(.largeTitle)
				.bold()
				.padding()
			Button {
				withAnimation {
					isAnimated = true
				}
				DispatchQueue.main.async {
					viewModel?.startWorkout()
				}
			} label: {
				Text("Start")
					.padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
					.frame(maxWidth: .infinity)
			}
			.background(.green)
			.foregroundColor(.white)
			.clipShape(RoundedRectangle(cornerRadius: 5))
			.font(.title)
			.padding(EdgeInsets(top:10, leading: 0, bottom: 0, trailing: 0))
			Button {
				isAnimated = false
			} label: {
				Text("Pause")
					.padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
					.frame(maxWidth: .infinity)
			}
			.background(.blue)
			.foregroundColor(.white)
			.clipShape(RoundedRectangle(cornerRadius: 5))
			.font(.title)
			.padding(EdgeInsets(top:10, leading: 0, bottom: 10, trailing: 0))
			Button {
				stopWorkout()
			} label: {
				Text("Stop")
					.padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
					.frame(maxWidth: .infinity)
			}
			.background(.red)
			.foregroundColor(.white)
			.clipShape(RoundedRectangle(cornerRadius: 5))
			.font(.title)
		}
		.onReceive(timer) { _ in
			guard isAnimated else { return }
			withAnimation {
				elapsedSeconds += 1
				workoutTimer = CalendarUtils.formatTime(seconds: elapsedSeconds)
			}
		}
		.onDisappear() {
			guard isAnimated else { return }
			stopWorkout()
		}
		.onAppear() {
			viewModel = WorkoutViewModel(context: context)
		}
	}
	func stopWorkout() {
		let finalDuration = elapsedSeconds
		DispatchQueue.main.async {
			viewModel?.workoutComplete(duration: finalDuration)
		}
		withAnimation {
			isAnimated = false
			workoutTimer = "00:00:00"
			elapsedSeconds = 0
		}
	}
}
#Preview {
	WorkoutView()
}
