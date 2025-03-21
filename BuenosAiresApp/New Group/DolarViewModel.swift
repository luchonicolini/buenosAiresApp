//
//  SenadoresViewModel.swift
//  BuenosAiresApp
//
//  Created by Luciano Nicolini on 18/03/2025.
//

// DolarViewModel.swift
import Foundation
import Combine

class DolarViewModel: ObservableObject {
    @Published var cotizaciones: [Dolar] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    private var isFetching = false // Evita solicitudes simultáneas

    func cargarCotizaciones() {
        guard !isFetching else { return } // Evita múltiples solicitudes
        isFetching = true
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "https://dolarapi.com/v1/dolares") else {
            self.errorMessage = "URL inválida"
            self.isLoading = false
            isFetching = false
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [Dolar].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                self?.isFetching = false
                if case .failure(let error) = completion {
                    self?.errorMessage = self?.mensajeDeError(error)
                    print("Error: \(error)")
                }
            }, receiveValue: { [weak self] cotizaciones in
                self?.cotizaciones = cotizaciones
                print("Cotizaciones cargadas: \(cotizaciones.count)")
            })
            .store(in: &cancellables)
    }
    
    // Función para generar mensajes de error más específicos
    private func mensajeDeError(_ error: Error) -> String {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                return "No hay conexión a internet"
            case .timedOut:
                return "La solicitud ha expirado"
            default:
                return "Error de red: \(urlError.localizedDescription)"
            }
        } else if error is DecodingError {
            return "Error al procesar los datos"
        } else {
            return "Error desconocido: \(error.localizedDescription)"
        }
    }
}
