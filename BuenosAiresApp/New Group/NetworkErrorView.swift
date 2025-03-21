//
//  NetworkErrorView.swift
//  BuenosAiresApp
//
//  Created by Luciano Nicolini on 21/03/2025.
//

import SwiftUI

struct NetworkErrorView: View {
    let errorMessage: String
    var retryAction: () -> Void = {}
    var iconSystemName: String = "wifi.exclamationmark"
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: iconSystemName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .foregroundColor(.red)
            
            Text("Oops, ha ocurrido un error")
                .font(.title)
                .fontWeight(.bold)
            
            Text(errorMessage)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            Button(action: {
                retryAction()
            }) {
                Text("Intentar de nuevo")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
}
#Preview {
    NetworkErrorView(errorMessage: "No se pueden cargar los datos Comprueba tu conexión")
}
