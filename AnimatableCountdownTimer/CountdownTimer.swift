//
//  CountdownTimer.swift
//  AnimatableCountdownTimer
//
//  Created by Daniel Tischenko on 06.01.2022.
//

import SwiftUI

private extension View {
    func capsuled() -> some View {
        self
            .foregroundColor(.white)
            .padding(.vertical, 4)
            .padding(.horizontal)
            .background(
                Capsule()
                    .fill(Color.red)
                    .opacity(0.75)
            )
            .clipped()
    }
}

struct CountdownTimer: View {
    @Binding var timeRemaining: Int

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        Text(String(timeRemaining))
            .font(.largeTitle.monospacedDigit())
            .capsuled()
            .onReceive(timer) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    timer.upstream.connect().cancel()
                }
            }
    }
}

struct CountdownTimer_Previews: PreviewProvider {
    static var previews: some View {
        CountdownTimer(timeRemaining: .constant(100))
            .previewLayout(.sizeThatFits)
    }
}
