//
//  ApiViewModel .swift
//  BuenosAiresApp
//
//  Created by Luciano Nicolini on 18/03/2025.
//
// DolarCardView.swift


import SwiftUI



struct DolarCardView: View {
    let dolar: Dolar
    @State private var isExpanded = false
    
    // Mapa de colores para tipos de dólar
    private let colorMap: [String: Color] = [
        "oficial": .green,
        "blue": Color(red: 0.2, green: 0.6, blue: 0.9),
        "bolsa": .orange, "mep": .orange,
        "ccl": .purple, "contadoconliqui": .purple,
        "cripto": Color(red: 0.0, green: 0.8, blue: 0.6),
        "tarjeta": .teal,
        "solidario": .black, "turista": .black,
        "mayorista": .brown
    ]
    
    // Mapa de descripciones para tipos de dólar
    private let tipoDescripcion: [String: String] = [
        "oficial": "Tipo de cambio oficial",
        "blue": "Mercado informal",
        "bolsa": "Mercado electrónico de pagos", "mep": "Mercado electrónico de pagos",
        "ccl": "Contado con liquidación", "contadoconliqui": "Contado con liquidación",
        "cripto": "Criptomonedas",
        "tarjeta": "Consumos con tarjeta",
        "solidario": "Dólar turista/solidario",
        "turista": "Dólar turista/solidario",
        "mayorista": "Mercado mayorista"
    ]
    
    // Constantes globales para estilos
    private let cardCornerRadius: CGFloat = 16
    private let shadowRadius: CGFloat = 10
    private let paddingHorizontal: CGFloat = 16
    private let paddingVertical: CGFloat = 8
    
    private var cardAccentColor: Color {
        colorMap[dolar.casa.lowercased()] ??
        colorMap[dolar.nombre.lowercased()] ?? .gray
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Cabecera
            headerView
            
            // Contenido principal
            VStack(spacing: 16) {
                // Precios
                HStack(spacing: 20) {
                    precioView(label: "Compra", value: dolar.compra, iconName: "arrow.down.circle.fill", iconColor: .green)
                    
                    Divider()
                        .frame(width: 1, height: 60)
                        .background(Color.primary.opacity(0.2))
                    
                    precioView(label: "Venta", value: dolar.venta, iconName: "arrow.up.circle.fill", iconColor: .red)
                }
                .padding(.top, 8)
                
                // Info de actualización
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.secondary)
                        .font(.system(size: 12))
                    
                    Text("Actualizado: \(formatearFecha(dolar.fechaActualizacion))")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    expandButton
                }
                
                // Contenido expandible
                if isExpanded {
                    expandedContent
                }
            }
            .padding(16)
            .background(Color(.systemBackground))
            .cornerRadius(cardCornerRadius, corners: [.bottomLeft, .bottomRight])
        }
        .shadow(color: Color.black.opacity(0.1), radius: shadowRadius, x: 0, y: 5)
        .padding(.horizontal, paddingHorizontal)
        .padding(.vertical, paddingVertical)
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        HStack {
            Text("Dólar \(dolar.nombre)")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            Spacer()
        }
        .padding(EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20))
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    cardAccentColor.opacity(0.8),
                    cardAccentColor.opacity(0.6)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(cardCornerRadius, corners: [.topLeft, .topRight])
    }
    
    private var expandButton: some View {
        Button(action: {
            withAnimation(.spring()) {
                isExpanded.toggle()
            }
        }) {
            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                .foregroundColor(.secondary)
                .font(.system(size: 14, weight: .medium))
                .padding(8)
                .background(Color(.systemGray6))
                .clipShape(Circle())
        }
    }
    
    private var expandedContent: some View {
        VStack(spacing: 16) {
            Divider().background(Color(.systemGray5)).padding(.vertical, 6)
            
            // Brecha
            if let compra = dolar.compra, let venta = dolar.venta {
                infoRow(title: "Brecha", value: "\(String(format: "%.2f", (venta - compra) / compra * 100))%", icon: "arrow.left.and.right")
            }
            
            // Tipo
            infoRow(
                title: "Tipo",
                value: tipoDescripcion[dolar.casa.lowercased()] ??
                      tipoDescripcion[dolar.nombre.lowercased()] ?? "Otros",
                icon: "banknote"
            )
        }
    }
    
    // MARK: - Helper Views
    
    private func precioView(label: String, value: Double?, iconName: String, iconColor: Color) -> some View {
        VStack(alignment: .center, spacing: 8) {
            Text(label)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.secondary)
            
            if let value = value {
                Text("$\(value.formattedDecimalString())")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
            } else {
                Text("--")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private func infoRow(title: String, value: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.secondary)
                .frame(width: 20)
            
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.primary)
        }
    }
    
    // MARK: - Helper Functions
    
    private func formatearFecha(_ fechaString: String) -> String {
        // Formato de entrada (el formato que recibe la API)
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        // Convertir la cadena de entrada a una fecha
        guard let fecha = inputFormatter.date(from: fechaString) else { return fechaString }
        
        // Formato de salida (el formato que deseas mostrar)
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        // Devolver la fecha formateada
        return outputFormatter.string(from: fecha)
    }
}

// Extensión necesaria para formatear números decimales
extension Double {
    func formattedDecimalString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: self)) ?? String(format: "%.2f", self)
    }
}

// Extensiones para esquinas redondeadas
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// Vista previa
struct DolarCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DolarCardView(dolar: Dolar(casa: "blue", nombre: "Dólar Blue", compra: 1100, venta: 1150, fechaActualizacion: "2023-05-10T12:30:00Z"))
                .previewLayout(.sizeThatFits)
                .padding()
                .preferredColorScheme(.light)
            
            DolarCardView(dolar: Dolar(casa: "oficial", nombre: "Dólar Oficial", compra: 870, venta: 910, fechaActualizacion: "2023-05-10T12:30:00Z"))
                .previewLayout(.sizeThatFits)
                .padding()
                .preferredColorScheme(.dark)
        }
    }
}

