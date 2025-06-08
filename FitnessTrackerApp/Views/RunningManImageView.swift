//
//  SwiftUIView.swift
//  WorkoutTracker
//
//  Created by Robert le Clus on 2025/06/05.
//

import SwiftUI

struct RunningManImageView: View {
	@State private var currentFrame = 0
	@Binding var isAnimated: Bool
	let totalFrames = 12
	let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
	var body: some View {
		ZStack {
			Image("running_frame_\(currentFrame + 1)")
				.scaledToFit()
				.frame(width: 200, height: 200)
				.clipShape(Circle())
				.onReceive(timer) { _ in
					if !isAnimated {
						return
					}
					currentFrame = (currentFrame + 1) % totalFrames
				}
				.onDisappear {
					timer.upstream.connect().cancel()
				}
				.overlay {
					Circle().stroke(.black, lineWidth: 10)
				}
		}
	}
}

#Preview {
	RunningManImageView(isAnimated: Binding.constant(true))
}
