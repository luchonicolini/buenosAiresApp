//
//  MeshGradientView.swift
//  BuenosAiresApp
//
//  Created by Luciano Nicolini on 19/03/2025.
//

import SwiftUI

struct MeshGradientBackground: View {
    // Colores que usaremos para el gradiente
    let colors: [Color]
    
    // Estado para animar la posición de los blobs
    @State private var animateBlobs = false
    
    // Tiempo de animación
    let animationDuration: Double = 12.0
    
    init(colors: [Color] = [
        Color(red: 0.2, green: 0.15, blue: 0.65), // Azul profundo
        Color(red: 0.67, green: 0.2, blue: 0.55), // Púrpura
        Color(red: 0.97, green: 0.38, blue: 0.24), // Naranja
        Color(red: 0.1, green: 0.5, blue: 0.75) // Azul claro
    ]) {
        self.colors = colors
    }
    
    var body: some View {
        ZStack {
            // Color de fondo base
            Color.black
                .opacity(0.9)
                .ignoresSafeArea()
            
            // Primer blob
            BlobShape(offsetFactorX: animateBlobs ? 0.2 : -0.2,
                     offsetFactorY: animateBlobs ? -0.3 : 0.2)
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [colors[0], colors[0].opacity(0)]),
                        center: .center,
                        startRadius: 20,
                        endRadius: 350
                    )
                )
                .frame(width: 300, height: 300)
                .offset(x: -30, y: -100)
                .blur(radius: 50)
            
            // Segundo blob
            BlobShape(offsetFactorX: animateBlobs ? -0.2 : 0.3,
                     offsetFactorY: animateBlobs ? 0.2 : -0.2)
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [colors[1], colors[1].opacity(0)]),
                        center: .center,
                        startRadius: 20,
                        endRadius: 400
                    )
                )
                .frame(width: 400, height: 400)
                .offset(x: 80, y: 50)
                .blur(radius: 50)
            
            // Tercer blob
            BlobShape(offsetFactorX: animateBlobs ? 0.3 : -0.1,
                     offsetFactorY: animateBlobs ? -0.3 : 0.3)
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [colors[2], colors[2].opacity(0)]),
                        center: .center,
                        startRadius: 20,
                        endRadius: 300
                    )
                )
                .frame(width: 350, height: 350)
                .offset(x: -50, y: 70)
                .blur(radius: 50)
            
            // Cuarto blob
            BlobShape(offsetFactorX: animateBlobs ? -0.3 : 0.2,
                     offsetFactorY: animateBlobs ? 0.3 : -0.1)
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [colors[3], colors[3].opacity(0)]),
                        center: .center,
                        startRadius: 20,
                        endRadius: 350
                    )
                )
                .frame(width: 300, height: 300)
                .offset(x: 50, y: -50)
                .blur(radius: 50)
            
        }
        .onAppear {
            // Empezar la animación en loop
            withAnimation(
                Animation.easeInOut(duration: animationDuration)
                    .repeatForever(autoreverses: true)
            ) {
                animateBlobs.toggle()
            }
        }
    }
}

// Forma de blob personalizada para hacer el efecto orgánico
struct BlobShape: Shape {
    // Factores que controlan la distorsión del blob
    var offsetFactorX: CGFloat
    var offsetFactorY: CGFloat
    
    // Para animaciones
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(offsetFactorX, offsetFactorY) }
        set {
            offsetFactorX = newValue.first
            offsetFactorY = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        let centerX = width / 2
        let centerY = height / 2
        
        // Control points for the blob shape
        let topControlPoint = CGPoint(
            x: centerX + width * 0.4 * offsetFactorX,
            y: centerY - height * 0.5 + height * 0.1 * offsetFactorY
        )
        
        let rightControlPoint = CGPoint(
            x: centerX + width * 0.5 - width * 0.05 * offsetFactorX,
            y: centerY + height * 0.4 * offsetFactorY
        )
        
        let bottomControlPoint = CGPoint(
            x: centerX - width * 0.4 * offsetFactorX,
            y: centerY + height * 0.5 - height * 0.1 * offsetFactorY
        )
        
        let leftControlPoint = CGPoint(
            x: centerX - width * 0.5 + width * 0.05 * offsetFactorX,
            y: centerY - height * 0.4 * offsetFactorY
        )
        
        // Puntos entre los puntos de control
        let topRightPoint = CGPoint(
            x: (topControlPoint.x + rightControlPoint.x) / 2,
            y: (topControlPoint.y + rightControlPoint.y) / 2
        )
        
        let bottomRightPoint = CGPoint(
            x: (rightControlPoint.x + bottomControlPoint.x) / 2,
            y: (rightControlPoint.y + bottomControlPoint.y) / 2
        )
        
        let bottomLeftPoint = CGPoint(
            x: (bottomControlPoint.x + leftControlPoint.x) / 2,
            y: (bottomControlPoint.y + leftControlPoint.y) / 2
        )
        
        let topLeftPoint = CGPoint(
            x: (leftControlPoint.x + topControlPoint.x) / 2,
            y: (leftControlPoint.y + topControlPoint.y) / 2
        )
        
        // Dibujar el blob
        path.move(to: topLeftPoint)
        path.addQuadCurve(to: topRightPoint, control: topControlPoint)
        path.addQuadCurve(to: bottomRightPoint, control: rightControlPoint)
        path.addQuadCurve(to: bottomLeftPoint, control: bottomControlPoint)
        path.addQuadCurve(to: topLeftPoint, control: leftControlPoint)
        path.closeSubpath()
        
        return path
    }
}

// Vista de ejemplo para mostrar cómo se usa
struct MeshGradientBackgroundDemo: View {
    var body: some View {
        ZStack {
            // Aplica el fondo con gradiente mesh
            MeshGradientBackground()
            
            // Contenido de tu app encima del fondo
            VStack {
              
            }
        }
    }
}

// Para la vista previa en Xcode
struct MeshGradientBackground_Previews: PreviewProvider {
    static var previews: some View {
        MeshGradientBackgroundDemo()
    }
}
