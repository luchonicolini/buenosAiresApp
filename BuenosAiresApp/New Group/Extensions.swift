//
//  Extensions.swift
//  BuenosAiresApp
//
//  Created by Luciano Nicolini on 21/03/2025.
//

import Foundation
import SwiftUI

extension View {
    /// Oculta el teclado al tocar fuera del campo de texto.
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
