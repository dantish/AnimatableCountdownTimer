//
//  ContentView.swift
//  AnimatableCountdownTimer
//
//  Created by Daniel Tischenko on 06.01.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var timeRemaining: Int = 100

    var body: some View {
        VStack {
            CountdownTimer(timeRemaining: $timeRemaining.animation())
            CurrentTime()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
