//
//  ErrorView.swift
//  BuenosAiresApp
//
//  Created by Luciano Nicolini on 21/03/2025.
//

import SwiftUI

struct ErrorView: View {
    let error: String
    let retryAction: () -> Void

    var body: some View {
        VStack {
            Text("Error: \(error)")
                .foregroundColor(.red)
                .padding()

            Button("Reintentar", action: retryAction)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}
