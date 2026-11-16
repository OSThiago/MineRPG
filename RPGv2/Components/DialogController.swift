//
//  DialogController.swift
//  RPGv2
//
//  Created by Thiago de Oliveira Sousa on 08/11/26.
//

import SwiftUI
import Combine

/// Controla a exibição de diálogos letra por letra na BattleView.
/// O BattleManager e o Player não sabem nada sobre UI — apenas chamam `show(_:)` e aguardam.
@MainActor
final class DialogController: ObservableObject {

    /// Instância compartilhada acessível de qualquer lugar do código.
    static let shared = DialogController()

    // Texto parcialmente revelado que a view observa
    @Published var displayedText: String = ""
    @Published var isVisible: Bool = false

    // Intervalo entre cada letra (em segundos)
    var letterInterval: TimeInterval = 0.04

    // Tempo que o diálogo fica visível após terminar de digitar
    var visibleDuration: TimeInterval = 1.5

    // MARK: - API pública

    /// Exibe um texto letra por letra e aguarda até ele sumir.
    /// Retorna quando o ciclo completo terminou (pode ser awaited pelo BattleManager).
    func show(_ text: String) async {
        guard !text.isEmpty else { return }

        displayedText = ""
        isVisible = true

        // Digita letra por letra
        for char in text {
            displayedText.append(char)
            try? await Task.sleep(nanoseconds: UInt64(letterInterval * 1_000_000_000))
        }

        // Fica visível por `visibleDuration` antes de sumir
        try? await Task.sleep(nanoseconds: UInt64(visibleDuration * 1_000_000_000))

        isVisible = false
        displayedText = ""
    }
}
