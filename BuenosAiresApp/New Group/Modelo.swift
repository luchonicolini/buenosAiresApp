//
//  Senador .swift
//  BuenosAiresApp
//
//  Created by Luciano Nicolini on 18/03/2025.
//

// Modelo.swift
import Foundation

struct Dolar: Identifiable, Decodable {
    var id = UUID()
    let casa: String
    let nombre: String
    let compra: Double?
    let venta: Double?
    let fechaActualizacion: String
    
    enum CodingKeys: String, CodingKey {
        case casa, nombre, compra, venta
        case fechaActualizacion = "fechaActualizacion"
    }
}
