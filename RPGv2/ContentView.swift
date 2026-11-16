//
//  ContentView.swift
//  RPGv2
//
//  Created by Thiago de Oliveira Sousa on 19/07/26.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var router = Router()
    @StateObject private var gameSession = GameSession()

    var body: some View {
        buildView(for: router.currentScene)
            .ignoresSafeArea()
            .environmentObject(router)
            .environmentObject(gameSession)
    }

    @ViewBuilder
    private func buildView(for scene: AppScene) -> some View {
        switch scene {
        case .select:
            SelectionView()
        case .battle:
            BattleView(
                player: gameSession.selectedPlayer ?? Steve(),
                enemy: gameSession.selectedEnemy ?? Steve()
            )
        }
    }
}

#Preview {
    ContentView()
}
