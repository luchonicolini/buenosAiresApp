//
//  CustomSearchBar.swift
//  BuenosAiresApp
//
//  Created by Luciano Nicolini on 21/03/2025.
//

import SwiftUI

struct CustomSearchBar: View {
    @Binding var text: String // Texto de búsqueda
    @FocusState private var isSearchActive: Bool // Estado de foco del campo de texto
    @State private var showClearButton = true // Controla si se muestra el botón de limpiar
    
    var placeholder: String // Placeholder personalizado
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(.thinMaterial)
                .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3) // Sombra
            
            HStack {
                // Ícono de búsqueda o botón de limpiar
                Image(systemName: showClearButton ? "magnifyingglass" : "xmark")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.secondary)
                    .onTapGesture {
                        withAnimation {
                            if !showClearButton {
                                text = "" // Limpia el texto
                            }
                            showClearButton.toggle()
                        }
                    }
                
                // Campo de texto
                TextField(placeholder, text: $text)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .focused($isSearchActive)
                    .onTapGesture {
                        withAnimation {
                            showClearButton = true
                        }
                    }
                
                // Botón de limpiar (opcional)
                if !text.isEmpty {
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 12)
        }
        .frame(height: 50)
        .padding(.horizontal)
    }
}

#Preview {
    // Estado para el texto de búsqueda
    @State var searchText = ""
    
    return CustomSearchBar(text: $searchText, placeholder: "Buscar cotización...")
        .padding()
}
