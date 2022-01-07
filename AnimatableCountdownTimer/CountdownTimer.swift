//
//  CountdownTimer.swift
//  AnimatableCountdownTimer
//
//  Created by Daniel Tischenko on 06.01.2022.
//

import Combine
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

private struct AnimatableText: View {
    private struct IndexedCharacter: Identifiable {
        let index: Int
        let char: Character

        var id: String {
            "\(index)-\(char)"
        }
    }

    let text: String
    private let indexedCharacters: [IndexedCharacter]

    init(_ text: String) {
        self.text = text
        self.indexedCharacters = text
            .map(Character.init)
            .enumerated()
            .map(IndexedCharacter.init)
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(indexedCharacters) { item in
                Text(String(item.char))
                    .font(.largeTitle.monospacedDigit())
                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
                    .id("\(Self.self)-\(item.id)")
            }
        }
    }
}

private class TimerViewModel: ObservableObject {
    let timer: AnyPublisher<Date, Never>
    private var cancellable: Cancellable?

    init() {
        let timer = Timer.publish(every: 1, on: .main, in: .common)
        self.cancellable = timer.connect()
        self.timer = timer.eraseToAnyPublisher()
    }

    func stopTimer() {
        cancellable?.cancel()
        cancellable = nil
    }

}

struct CountdownTimer: View {
    @Binding var timeRemaining: Int

    @StateObject
    private var viewModel = TimerViewModel()

    var body: some View {
        AnimatableText(String(timeRemaining))
            .capsuled()
            .onReceive(viewModel.timer) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    viewModel.stopTimer()
                }
            }
    }
}

struct CurrentTime: View {
    @StateObject
    private var viewModel = TimerViewModel()

    @State private var currentDate = Date()

    private var formattedCurrentTime: String {
        currentDate.formatted(date: .omitted, time: .standard)
    }

    var body: some View {
        AnimatableText(formattedCurrentTime)
            .capsuled()
            .onReceive(viewModel.timer) { date in
                withAnimation {
                    currentDate = date
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

struct CurrentTime_Previews: PreviewProvider {
    static var previews: some View {
        CurrentTime()
            .previewLayout(.sizeThatFits)
    }
}
