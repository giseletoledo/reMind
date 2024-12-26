//
//  SplashScreenView.swift
//  reMind
//
//  Created by GISELE TOLEDO on 26/12/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false

    var body: some View {
        ZStack {
            reBackground()
                .ignoresSafeArea() // Garante que o fundo ocupe toda a tela

            VStack {
                if isActive {
                    // Navega para a tela principal após o tempo de exibição da splash screen
                    NavigationStack {
                        BoxesView(viewModel: BoxViewModel())
                    }
                } else {
                    // Conteúdo da splash screen
                    VStack {
                        Image("splashImage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    }
                    .onAppear {
                        // Simula um tempo de carregamento de 3 segundos
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                self.isActive = true
                            }
                        }
                    }
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
