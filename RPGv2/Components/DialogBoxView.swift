//
//  DialogBoxView.swift
//  RPGv2
//
//  Created by Thiago de Oliveira Sousa on 08/11/26.
//

import SwiftUI

/// Caixa de diálogo estilo RPG que exibe texto letra por letra.
/// Observa um DialogController e se mostra/esconde automaticamente.
struct DialogBoxView: View {

    @ObservedObject var controller: DialogController

    var body: some View {
        if controller.isVisible {
            ZStack(alignment: .leading) {
                // Fundo estilo Minecraft (borda pixelada)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.black.opacity(0.85))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.gray.opacity(0.6), lineWidth: 2)
                    )

                Text(controller.displayedText)
                    .font(.system(size: 16, weight: .medium, design: .monospaced))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 40)
//            .transition(.opacity.combined(with: .move(edge: .bottom)))
            .animation(.easeInOut(duration: 0.2), value: controller.isVisible)
        }
    }
}

// MARK: - Preview

#Preview {
    struct PreviewWrapper: View {
        @StateObject var controller = DialogController()

        var body: some View {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack {
                    Spacer()
                    DialogBoxView(controller: controller)
                        .padding(.horizontal, 32)
                }
            }
            .task {
                // Simula sequência de diálogos para o preview
                await controller.show("Steve usou Espada de Diamante!")
                await controller.show("Zombie recebeu 15 de dano.")
                await controller.show("É o turno do Zombie...")
            }
        }
    }

    return PreviewWrapper()
}
