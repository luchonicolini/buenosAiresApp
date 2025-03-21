//
//  Home.swift
//  BuenosAiresApp
//
//  Created by Luciano Nicolini on 18/03/2025.
//

import SwiftUI

struct DolarView: View {
    @StateObject private var viewModel = DolarViewModel()
    @State private var searchText = "" // Texto de búsqueda
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.background
                    .edgesIgnoringSafeArea(.all)
                
                contentView()
                    .onTapGesture {
                        hideKeyboard() // Oculta el teclado al tocar fuera del campo de búsqueda
                    }
            }
            .navigationTitle("Cotizaciones")
            .onAppear {
                viewModel.cargarCotizaciones()
            }
        }
    }
    
    @ViewBuilder
    private func contentView() -> some View {
        if viewModel.isLoading {
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(1.5)
                
                Text("Cargando cotizaciones...")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background.opacity(0.8))
            .transition(.opacity)
        } else if let error = viewModel.errorMessage {
            NetworkErrorView(errorMessage: error) {
                viewModel.cargarCotizaciones()
            }
            .transition(.move(edge: .bottom))
            .animation(.easeInOut(duration: 0.3), value: viewModel.errorMessage)
        } else {
            VStack(spacing: 0) {
                // Barra de búsqueda personalizada
                CustomSearchBar(text: $searchText, placeholder: "Buscar cotización...")
                
                // Lista de cotizaciones filtradas
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredCotizaciones) { dolar in
                            DolarCardView(dolar: dolar)
                                .padding(.horizontal)
                                .id(dolar.id)
                                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                                .scrollTransition { content, phase in
                                    content
                                        .scaleEffect(phase.isIdentity ? 1 : 0.75)
                                        .opacity(phase.isIdentity ? 1 : 0)
                                }
                        }
                    }
                    .padding(.vertical, 16)
                }
            }
        }
    }
    
    // Filtrado de cotizaciones
    private var filteredCotizaciones: [Dolar] {
        if searchText.isEmpty {
            return viewModel.cotizaciones
        } else {
            return viewModel.cotizaciones.filter { dolar in
                dolar.nombre.localizedCaseInsensitiveContains(searchText) ||
                dolar.casa.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func refreshData() async {
        await MainActor.run {
            viewModel.cargarCotizaciones()
        }
    }
}

#Preview {
    DolarView()
}




