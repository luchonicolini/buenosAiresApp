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
    
    func cargarCotizaciones() {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "https://dolarapi.com/v1/dolares") else {
            self.errorMessage = "URL inválida"
            self.isLoading = false
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Dolar].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                    print("Error: \(error)")
                }
            }, receiveValue: { [weak self] cotizaciones in
                self?.cotizaciones = cotizaciones
                print("Cotizaciones cargadas: \(cotizaciones.count)")
            })
            .store(in: &cancellables)
    }
}
