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

struct CountdownTimer: View {
    @Binding var timeRemaining: Int

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        AnimatableText(String(timeRemaining))
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
