//
//  Home.swift
//  BuenosAiresApp
//
//  Created by Luciano Nicolini on 18/03/2025.
//

import SwiftUI

struct DolarView: View {
    @StateObject private var viewModel = DolarViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6)
                    .edgesIgnoringSafeArea(.all)
                
                contentView()
            }
            .navigationTitle("Cotizaciones del Dólar")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.cargarCotizaciones()
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        } else {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                    .disabled(viewModel.isLoading) // Deshabilita el botón mientras carga
                }
            }
            .onAppear {
                viewModel.cargarCotizaciones()
            }
        }
    }
    
    @ViewBuilder
    private func contentView() -> some View {
        if viewModel.isLoading {
            ProgressView("").padding()
        } else if let error = viewModel.errorMessage {
            ErrorView(error: error) {
                viewModel.cargarCotizaciones()
            }
        } else if viewModel.cotizaciones.isEmpty {
            Text("No se encontraron cotizaciones").padding()
        } else {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.cotizaciones) { dolar in
                        DolarCardView(dolar: dolar)
                            .padding(.horizontal)
                    }
                }
                .padding(.top)
                .padding(.bottom)
            }
        }
    }
}

#Preview {
    DolarView()
}




