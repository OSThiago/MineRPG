//
//  Router.swift
//  RPGv2
//
//  Created by Thiago de Oliveira Sousa on 20/07/26.
//

import SwiftUI
import Combine

enum AppScene {
    case battle
    case select
}

final class Router: ObservableObject {
    @Published var currentScene: AppScene = .select

    func navigate(to scene: AppScene) {
        withAnimation(.easeInOut(duration: 0.1)) {
            self.currentScene = scene
        }
    }

    @ViewBuilder
    func buildedView(scene: AppScene) -> some View {
        switch scene {
        case .battle:
            BattleView()
        case .select:
            SelectionView()
        }
    }
}
